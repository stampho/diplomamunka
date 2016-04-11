import QtQuick 2.6
import QtQuick.Controls 1.5
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
        width: parent.width
        height: 50

        TextField {
            id: urlField

            anchors.fill: parent
            text: webEngineView && webEngineView.url
            onAccepted: webEngineView.url = utils.fromUserInput(text)
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
        }
    }
}
