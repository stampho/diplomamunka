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

    Settings {
        id: appSettings

        property alias lockUrlBar: lockUrlBar.checked
    }

    WebEngineViewListModel {
        id: viewListModel

        function createWebEngineView() {
            var webEngineView = newWebEngineView(webView)

            webEngineView.loadingChanged.connect(function(loadRequest){
                    if (!urlBar.lock && loadRequest.status == WebEngineView.LoadSucceededStatus)
                        urlBar.state = "closed"

                    if (!urlBar.lock && loadRequest.status == WebEngineView.LoadStartedStatus)
                        urlBar.state = "opened"

                    if (loadRequest.status != WebEngineView.LoadStartedStatus)
                        historyListView.currentIndex = currentWebEngineView.navigationHistory.backItems.rowCount()
                })
        }

        function selectWebEngineView(index) {
            currentWebEngineView = get(index).webEngineView
            webView.push({ item: currentWebEngineView, replace: true })
            tabListView.currentIndex = index
            historyListView.currentIndex = currentWebEngineView.navigationHistory.backItems.rowCount()
        }
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
                    viewListModel.createWebEngineView()
                    viewListModel.selectWebEngineView(viewListModel.count - 1)
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
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("&Find")
                shortcut: "Ctrl+f"
                onTriggered: findBar.show()
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
        z: parent.z + 1

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
                onClicked: {
                    historyListView.currentIndex -= 1
                    currentWebEngineView.goBack()
                    navigationAnimation.start()
                }
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: currentWebEngineView && currentWebEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: {
                    historyListView.currentIndex += 1
                    currentWebEngineView.goForward()
                    navigationAnimation.start()
                }
            }

            AddressBar {
                id: addressBar
                Layout.fillWidth: true

                progress: (currentWebEngineView && currentWebEngineView.url != "") ? currentWebEngineView.loadProgress : -1
                iconUrl: currentWebEngineView ? currentWebEngineView.icon : ""
                pageUrl: currentWebEngineView ? currentWebEngineView.url : ""

                onAccepted: {
                    if (!currentWebEngineView) {
                        viewListModel.createWebEngineView()
                        viewListModel.selectWebEngineView(viewListModel.count - 1)
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

            initialItem: (tabSwitch.state == "left") ? tabListView : historyListView

            TabListView {
                id: tabListView
                visible: tabSwitch.state == "left"

                model: viewListModel
                state: (tabBar.state == "closed") ? "compact" : "wide"

                onSelected: viewListModel.selectWebEngineView(index)
            }

            HistoryListView {
                id: historyListView
                visible: tabSwitch.state == "right"

                model: currentWebEngineView.navigationHistory.items
                state: (tabBar.state == "closed") ? "compact" : "wide"

                onSelected: {
                    navigationAnimation.start()
                    currentWebEngineView.goBackOrForward(offset)
                }
            }

            delegate: StackViewDelegate {
                replaceTransition: StackViewTransition {
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: (enterItem.model == viewListModel) ? -enterItem.width : enterItem.width
                        to: 0
                        duration: 300
                    }
                    PropertyAnimation {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: (exitItem.model == viewListModel) ? -exitItem.width : exitItem.width
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
                id: tabSwitch

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10

                height: 20

                leftText: width > 60 ? "Tabs" : "T"
                rightText: width > 60 ? "History" : "H"

                state: "left"

                onClicked: tabBarStack.push({item: (state == "left") ? tabListView : historyListView, replace: true})
            }
        }
    }

    StackView {
        id: webView

        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: tabBar.right
        anchors.right: parent.right

        clip: true

        delegate: StackViewDelegate {
            replaceTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: (enterItem.index < exitItem.index) ? -enterItem.height : enterItem.height
                    to: 0
                    duration: 300
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: (enterItem.index < exitItem.index) ? exitItem.height : -exitItem.height
                    duration: 300
                }
            }
        }
    }

    SystemPalette { id: palette }

    FindBar {
        id: findBar
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: urlBar.bottom
        anchors.topMargin: -10

        width: 180
        height: 45

        color: palette.window

        onFindNext: currentWebEngineView.findText(text)
        onFindPrev: currentWebEngineView.findText(text, WebEngineView.FindBackward)

        onStateChanged: {
            if (state == "hidden" && currentWebEngineView) {
                currentWebEngineView.findText("");
                currentWebEngineView.forceActiveFocus();
            }
        }
    }

    SequentialAnimation {
        id: navigationAnimation
        property int d: 600

        PropertyAnimation {
            target: currentWebEngineView
            property: "opacity"
            from: 1.0
            to: 0.1
            duration: navigationAnimation.d
        }

        PropertyAnimation {
            target: currentWebEngineView
            property: "opacity"
            from: 0.1
            to: 1.0
            duration: navigationAnimation.d
        }

        /*
        ParallelAnimation {
            PropertyAnimation {
                target: currentWebEngineView
                property: "rotation"
                from: 0
                to: 360
                duration: navigationAnimation.d
            }

            PropertyAnimation {
                target: currentWebEngineView
                property: "scale"
                from: 1.0
                to: 0.0
                duration: navigationAnimation.d
            }
        }

        ParallelAnimation {
            PropertyAnimation {
                target: currentWebEngineView
                property: "rotation"
                from: 0
                to: 360
                duration: navigationAnimation.d
            }

            PropertyAnimation {
                target: currentWebEngineView
                property: "scale"
                from: 0.0
                to: 1.0
                duration: navigationAnimation.d
            }
        }
        */
    }

    Component.onCompleted: {
        utils.setLocale("hu")
        WebEngine.settings.touchIconsEnabled = true
        viewListModel.createWebEngineView()
        viewListModel.selectWebEngineView(viewListModel.count - 1)
        currentWebEngineView.url = Qt.resolvedUrl("http://www.google.com")
    }
}
