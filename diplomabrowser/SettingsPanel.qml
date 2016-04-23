import QtQuick 2.6
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

Rectangle {
    id: root

    default property alias contents: contentLayout.data

    property Component checkBoxStyle: CheckBoxStyle {
        indicator: Rectangle {
            implicitWidth: 16
            implicitHeight: 16
            radius: 4
            border.color: control.enabled ? "white" : Qt.rgba(0.3, 0.3, 0.3, 1.0)
            border.width: 1
            color: "transparent"

            Rectangle {
                visible: control.checked
                color: control.enabled ? "white" : Qt.rgba(0.3, 0.3, 0.3, 1.0)
                radius: 2
                anchors.fill: parent
                anchors.margins: 4
            }
        }

        label: Text {
            color: control.enabled ? "white" : Qt.rgba(0.3, 0.3, 0.3, 1.0)
            font.pixelSize: 16
            text: control.text
        }
    }

    property Component textFieldStyle: TextFieldStyle {
        background: Rectangle {
            color: "transparent"
            border.color: Qt.rgba(0.8, 0.8, 0.8, 1.0)
            border.width: 1
            radius: 4
        }

        textColor: "white"
    }


    border.width: 1
    radius: 4

    visible: false
    z: parent.z + 10

    state: "hidden"
    states: [
        State {
            name: "shown"
            PropertyChanges { target: root; visible: true }
            PropertyChanges { target: root; scale: 1.0 }
            StateChangeScript { script: root.forceActiveFocus() }
        },
        State {
            name: "hidden"
            PropertyChanges { target: root; visible: false }
            PropertyChanges { target: root; scale: 0.0 }
        }
    ]

    transitions: [
        Transition {
            from: "shown"
            to: "hidden"

            SequentialAnimation {
                NumberAnimation {
                    target: root
                    property: "scale"
                    duration: 500
                    easing.type: Easing.InBack
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
                    property: "scale"
                    duration: 500
                    easing.type: Easing.OutBack
                }
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XandYAxis
        drag.minimumX: 0
        drag.maximumX: root.parent.width
        drag.minimumY: 0
        drag.maximumY: root.parent.height

        preventStealing: true
        hoverEnabled: true

        onPressed: { parent.anchors.centerIn = undefined }

        FlatButton {
            id: closeButton

            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5

            width: 20; height: 20
            text: "X"
            shortcut: "Esc"

            onClicked: root.state = "hidden"
        }

        FlatButton {
            id: okButton

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            width: 60; height: 30
            text: "Ok"
            shortcut: "Return"

            onClicked: root.state = "hidden"
        }

        Rectangle {
            anchors.fill: parent
            border.width: 1
            border.color: Qt.rgba(0.3, 0.3, 0.3, 1.0)
            radius: 8
            color: "transparent"

            anchors.leftMargin: 30
            anchors.rightMargin: 30
            anchors.topMargin: 25
            anchors.bottomMargin: 45

            Flickable {
                id: content

                anchors.fill: parent
                anchors.margins: 10

                contentHeight: contentLayout.height
                clip: true

                ColumnLayout { id: contentLayout }
            }
        }
    }
}
