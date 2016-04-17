import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtWebEngine 1.3
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Diploma Browser")

    property WebEngineView currentWebEngineView: null

    function createWebEngineView() {
        var webEngineView = Qt.createQmlObject("
                import QtQuick 2.5\n
                import QtWebEngine 1.3\n
                WebEngineView {\n
                    anchors.fill: parent\n
                    visible: false\n
                }\n
            ", webFlickable.contentItem)

        webEngineView.loadingChanged.connect(function(loadRequest){
                if (!urlBar.lock && loadRequest.status == WebEngineView.LoadSucceededStatus)
                    urlBar.state = "closed"

                if (!urlBar.lock && loadRequest.status == WebEngineView.LoadStartedStatus)
                    urlBar.state = "opened"
            })

        tabView.model.append({ "webEngineView": webEngineView })

        return webEngineView
    }

    function selectWebEngineView(index) {
        if (tabView.currentIndex >= 0) {
            var oldWebEngineView = tabView.model.get(tabView.currentIndex).webEngineView
            oldWebEngineView.visible = false
        }

        var newWebEngineView = tabView.model.get(index).webEngineView
        newWebEngineView.visible = true
        tabView.currentIndex = index

        return newWebEngineView
    }

    Settings {
        id: appSettings

        property alias lockUrlBar: lockUrlBar.checked
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: "Ctrl+l"
                onTriggered: {
                    urlBar.state = "opened"
                    addressBar.forceActiveFocus()
                }
            }
            MenuItem {
                text: qsTr("New &Tab")
                shortcut: StandardKey.AddTab
                onTriggered: {
                    createWebEngineView();
                    currentWebEngineView = selectWebEngineView(tabView.model.count - 1)
                    urlBar.state = "opened"
                    addressBar.forceActiveFocus()
                }
            }

            MenuItem {
                text: qsTr("&Quit")
                shortcut: "Ctrl+q"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("View")
            MenuItem {
                id: lockUrlBar
                text: qsTr("&Lock URL Bar")
                checkable: true
                checked: urlBar.lock
            }
        }
    }

    SliderBar {
        id: urlBar
        pos: parent.y
        width: parent.width - 4
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter

        orientation: Qt.Horizontal

        property bool lock: appSettings.lockUrlBar

        RowLayout {
            anchors.fill: parent
            spacing: 2

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: currentWebEngineView && currentWebEngineView.canGoBack
                text: "<"

                shortcut: "Ctrl+["
                onClicked: currentWebEngineView.goBack()
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: currentWebEngineView && currentWebEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: currentWebEngineView.goForward()
            }

            AddressBar {
                id: addressBar
                Layout.fillWidth: true

                progress: (currentWebEngineView && currentWebEngineView.url != "") ? currentWebEngineView.loadProgress : -1
                iconUrl: currentWebEngineView ? currentWebEngineView.icon : ""
                pageUrl: currentWebEngineView ? currentWebEngineView.url : ""

                onAccepted: {
                    if (!currentWebEngineView) {
                        createWebEngineView()
                        currentWebEngineView = selectWebEngineView(tabView.model.count - 1)
                    }
                    currentWebEngineView.url = addressUrl
                }
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                text: currentWebEngineView && currentWebEngineView.loading ? "X" : "R"
                enabled: currentWebEngineView

                shortcut: "Ctrl+r"
                onClicked: currentWebEngineView && currentWebEngineView.loading ? currentWebEngineView.stop() : currentWebEngineView.reload()
            }
        }
    }

    SliderBar {
        id: tabBar

        pos: parent.x
        width: 250
        minSize: 80
        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom

        orientation: Qt.Vertical

        StackView {
            id: tabBarStack

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: tabControl.top

            initialItem: tabView

            ListView {
                id: tabView

                spacing: 5

                model: ListModel { }
                clip: true
                x: 0

                highlightFollowsCurrentItem: true
                highlight: Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    color: "transparent"
                    z: parent.z + 2

                    height: 50
                    width: 50

                    border.width: 1
                    border.color: "black"
                    radius: 8
                }

                delegate: tabBar.state == "closed" ? compactDelegate : wideDelegate

                property Component compactDelegate: Component {
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        z: parent.z + 1
                        radius: 8

                        height: 50
                        color: "white"

                        Image {
                            anchors.centerIn: parent
                            width: 48; height: 48
                            sourceSize: Qt.size(width, height)
                            source: webEngineView ? webEngineView.icon : ""
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: currentWebEngineView = selectWebEngineView(index)
                        }
                    }
                }
                property Component wideDelegate : Component {
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        z: parent.z + 1
                        radius: 8

                        height: 30
                        color: "white"

                        RowLayout {
                            anchors.fill: parent
                            anchors.verticalCenter:  parent.verticalCenter
                            anchors.leftMargin: 5

                            Image {
                                width: 16; height: 16;
                                sourceSize: Qt.size(width, height)
                                source: webEngineView ? webEngineView.icon : ""
                            }
                            Text {
                                Layout.fillWidth: true
                                text: webEngineView ? webEngineView.title : ""
                                font.pixelSize: 16
                                clip: true
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: currentWebEngineView = selectWebEngineView(index)
                        }
                    }
                }
            }
            ListView {
                id: historyView

                spacing: 5

                model: currentWebEngineView.navigationHistory.items
                clip: true
                x: width

                highlightFollowsCurrentItem: true
                highlight: Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    color: "transparent"
                    z: parent.z + 2

                    height: 50
                    width: 50

                    border.width: 1
                    border.color: "black"
                    radius: 8
                }

                delegate: tabBar.state == "closed" ? compactDelegate : wideDelegate

                property Component compactDelegate: Component {
                    Rectangle {
                        id: tegla
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        z: parent.z + 1
                        radius: 8

                        height: 50
                        color: "white"

                        Image {
                            anchors.centerIn: parent
                            width: 48; height: 48
                            sourceSize: Qt.size(width, height)
                            source: icon
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                historyView.currentIndex = index
                                currentWebEngineView.goBackOrForward(offset)
                            }
                        }
                    }
                }
                property Component wideDelegate : Component {
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5

                        z: parent.z + 1
                        radius: 8

                        height: 30
                        color: "white"

                        RowLayout {
                            anchors.fill: parent
                            anchors.verticalCenter:  parent.verticalCenter
                            anchors.leftMargin: 5

                            Image {
                                width: 16; height: 16;
                                sourceSize: Qt.size(width, height)
                                source: icon
                            }
                            Text {
                                Layout.fillWidth: true
                                text: title
                                font.pixelSize: 16
                                clip: true
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                historyView.currentIndex = index
                                currentWebEngineView.goBackOrForward(offset)
                            }
                        }
                    }
                }
            }

            delegate: StackViewDelegate {
                replaceTransition: StackViewTransition {
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: enterItem.x
                        to: 0
                        duration: 300
                    }
                    PropertyAnimation {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: (enterItem.x < 0) ? exitItem.width : -exitItem.width
                        duration: 300
                    }
                }
            }
        }

        Rectangle {
            id: tabControl

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 50
            color: "transparent"

            BrowserSwitch {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10

                height: 20

                leftText: width > 60 ? "Tabs" : "T"
                rightText: width > 60 ? "History" : "H"

                state: "left"

                onClicked: {
                    tabBarStack.push({item: (state == "left") ? tabView : historyView, replace: true})
                }
            }
        }
    }

    Flickable {
        id: webFlickable

        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: tabBar.right
        anchors.right: parent.right
    }

    Component.onCompleted: {
        WebEngine.settings.touchIconsEnabled = true
        createWebEngineView()
        currentWebEngineView = selectWebEngineView(tabView.model.count - 1)
        currentWebEngineView.url = Qt.resolvedUrl("http://www.google.com")
    }
}
