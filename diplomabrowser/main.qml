import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtWebEngine 1.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Diploma Browser")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: "Ctrl+l"
                onTriggered: {
                    urlBar.open()
                    addressBar.forceActiveFocus()
                }
            }
            MenuItem {
                text: qsTr("&Quit")
                shortcut: "Ctrl+q"
                onTriggered: Qt.quit();
            }
        }
    }

    SliderBar {
        id: urlBar
        width: parent.width - 4
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter

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

    WebEngineView {
        id: webEngineView
        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        url: utils.fromUserInput("http://www.google.com")

        onLoadingChanged: {
            if (loadRequest.status == WebEngineView.LoadSucceededStatus)
                urlBar.close()

            if (loadRequest.status == WebEngineView.LoadStartedStatus)
                urlBar.open()
        }
    }
}
