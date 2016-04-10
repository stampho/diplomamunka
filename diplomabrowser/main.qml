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
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    WebEngineView {
        id: webEngineView
        anchors.fill: parent
        url: utils.fromUserInput("http://www.google.com")
    }
}
