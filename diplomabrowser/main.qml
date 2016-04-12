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
                    urlField.forceActiveFocus()
                    urlField.selectAll()
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
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            anchors.fill: parent
            spacing: 2

            BrowserButton {
                width: height
                height: parent.height
                enabled: webEngineView && webEngineView.canGoBack
                text: "<"

                shortcut: "Ctrl+["
                onClicked: webEngineView.goBack()
            }

            BrowserButton {
                width: height
                height: parent.height
                enabled: webEngineView && webEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: webEngineView.goForward()
            }

            TextField {
                id: urlField

                Layout.fillWidth: true
                Layout.fillHeight: true
                text: webEngineView && webEngineView.url
                onAccepted: webEngineView.url = utils.fromUserInput(text)

                style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        radius: 6
                        border.color: Qt.darker(urlBar.color, 1.2)
                        border.width: 1
                    }

                }
            }

            BrowserButton {
                width: height
                height: parent.height
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
