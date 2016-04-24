import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "controls"

Rectangle {
    id: root

    signal findNext(string text)
    signal findPrev(string text)

    SystemPalette { id: palette }

    visible: false
    radius: 8

    state: "hidden"
    states: [
        State {
            name: "shown"
            PropertyChanges { target: root; anchors.topMargin: -10 }
            PropertyChanges { target: root; visible: true }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; anchors.topMargin: -10 - root.height }
            PropertyChanges { target: root; visible: false }
        }
    ]

    transitions: [
        Transition {
            from: "shown"
            to: "hidden"

            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "anchors.topMargin"
                    duration: 300
                }
                NumberAnimation {
                    target: root
                    property: "visible"
                    duration: 0
                }
            }
        },
        Transition {
            from: "hidden"
            to: "shown"

            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "visible"
                    duration: 0
                }
                NumberAnimation {
                    target: root
                    property: "anchors.topMargin"
                    duration: 300
                }
            }
        }
    ]

    function show() {
        root.state = "shown";
        findField.forceActiveFocus();
    }

    function hide() {
        root.state = "hidden";
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

            onClicked: root.findNext(findField.text)
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
                        radius: 4
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: root.visible
                    onEntered: closeButton.visible = true
                    onExited: closeButton.visible = false

                    CloseButton {
                        id: closeButton

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 2

                        width: height
                        height: parent.height - 10

                        visible: false
                        enabled: root.visible

                        shortcut: "Esc"
                        onClicked: root.hide();
                    }
                }

                onActiveFocusChanged: activeFocus ? selectAll() : deselect()
                onAccepted: findNext(findField.text)
            }
        }

        BrowserButton {
            width: height
            height: findField.height
            text: ">"

            onClicked: root.findPrev(findField.text)
        }
    }
}
