import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtWebEngine 1.2
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Diploma Browser")

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
                enabled: webEngineView && webEngineView.canGoBack
                text: "<"

                shortcut: "Ctrl+["
                onClicked: webEngineView.goBack()
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: webEngineView && webEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: webEngineView.goForward()
            }

            AddressBar {
                id: addressBar
                Layout.fillWidth: true

                progress: webEngineView && webEngineView.loadProgress
                iconUrl: webEngineView && webEngineView.icon
                pageUrl: webEngineView && webEngineView.url

                onAccepted: webEngineView.url = addressUrl
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                text: webEngineView && webEngineView.loading ? "X" : "R"

                shortcut: "Ctrl+r"
                onClicked: webEngineView && webEngineView.loading ? webEngineView.stop() : webEngineView.reload()
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

        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: 5

            color: "white"
            radius: 8

            Image {
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter;
                width: 48; height: 48
                sourceSize: Qt.size(width, height)
                source: webEngineView && webEngineView.icon
                visible: tabBar.state == "closed"
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5

                height: 30
                border.width: 1
                radius: 4

                visible: tabBar.state == "opened"

                RowLayout {
                    anchors.fill: parent
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.leftMargin: 5

                    Image {
                        width: 24; height: 24;
                        sourceSize: Qt.size(width, height)
                        source: webEngineView && webEngineView.icon
                    }

                    Text {
                        Layout.fillWidth: true
                        text: webEngineView && webEngineView.title
                        font.pixelSize: 16
                        clip: true
                    }
                }
            }
        }
    }

    WebEngineView {
        id: webEngineView
        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: tabBar.right
        anchors.right: parent.right

        url: utils.fromUserInput("http://www.google.com")

        onLoadingChanged: {
            if (!urlBar.lock && loadRequest.status == WebEngineView.LoadSucceededStatus)
                urlBar.state = "closed"

            if (!urlBar.lock && loadRequest.status == WebEngineView.LoadStartedStatus)
                urlBar.state = "opened"
        }
    }
}
