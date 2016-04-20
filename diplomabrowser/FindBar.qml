import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

Rectangle {
    id: root

    visible: false
    radius: 8

    function show() {
        visible = true;
        findField.forceActiveFocus();
    }

    function hide() {
        visible = false;
        currentWebEngineView.forceActiveFocus();
    }

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.bottomMargin: 5
        anchors.leftMargin: 2
        anchors.rightMargin: 2

        spacing: 0

        BrowserButton {
            width: height
            height: findField.height
            text: "<"

            onClicked: console.log("back")
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true
            height: findField.height

            color: "white"
            radius: 4

            TextField {
                id: findField
                anchors.fill: parent

                style: TextFieldStyle {
                    padding.right: 20
                    background: Rectangle {
                        color: "transparent"
                        border.color: Qt.darker(palette.window, 2.0)
                        border.width: 1
                        radius: 4 // radius
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 2

                    width: height
                    height: parent.height - 10

                    opacity: 0.2

                    Text {
                        anchors.fill: parent
                        text: "X"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onPressed: root.hide()
                        onEntered: parent.opacity = 1.0
                        onExited: parent.opacity = 0.2
                    }
                }

                onActiveFocusChanged: activeFocus ? selectAll() : deselect()
                onAccepted: console.log("find: " + text)

                Keys.onPressed: {
                    if (event.key == Qt.Key_Escape && root.visible)
                        root.hide();
                }
            }
        }

        BrowserButton {
            width: height
            height: findField.height
            text: ">"

            onClicked: console.log("forward")
        }
    }
}
