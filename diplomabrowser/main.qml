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

        viewModel.append({ "webEngineView": webEngineView })

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

    ListModel {
        id: viewModel
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
                    currentWebEngineView = selectWebEngineView(viewModel.count - 1)
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
                        currentWebEngineView = selectWebEngineView(viewModel.count - 1)
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

        ListView {
            id: tabView
            anchors.fill: parent
            spacing: 5

            model: viewModel

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
                        onClicked: {
                            currentWebEngineView = selectWebEngineView(index)
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
                            width: 24; height: 24;
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
                        onClicked: {
                            currentWebEngineView = selectWebEngineView(index)
                        }
                    }
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
        createWebEngineView()
        currentWebEngineView = selectWebEngineView(viewModel.count - 1)
        currentWebEngineView.url = Qt.resolvedUrl("http://www.google.com")
    }
}
