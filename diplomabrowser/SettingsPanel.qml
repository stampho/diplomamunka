import QtQuick 2.6

Rectangle {
    id: root

    default property alias contents: content.data

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
            anchors.bottomMargin: 5

            width: 60; height: 30
            text: "Ok"
            shortcut: "Return"

            onClicked: root.state = "hidden"
        }

        Item {
            id: content

            anchors.fill: parent
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            anchors.topMargin: 40
            anchors.bottomMargin: 40
        }
    }
}
