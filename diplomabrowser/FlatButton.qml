import QtQuick 2.6

Rectangle {
    id: root

    property string text: ""
    property color bgColor: "white"
    property color fgColor: Qt.rgba(0.8, 0.8, 0.8, 1.0)
    property string shortcut: ""

    signal clicked()

    color: bgColor
    border.color: fgColor

    border.width: 1
    radius: 5

    state: "released"
    states: [
        State {
            name: "released"
            PropertyChanges { target: root; bgColor: "transparent" }
            PropertyChanges { target: root; fgColor: Qt.rgba(0.8, 0.8, 0.8, 1.0) }
        },
        State {
            name: "pressed"
            PropertyChanges { target: root; bgColor: "white" }
            PropertyChanges { target: root; fgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0) }
        },
        State {
            name: "hovered"
            PropertyChanges { target: root; bgColor: "transparent" }
            PropertyChanges { target: root; fgColor: "white" }
        }
    ]

    SequentialAnimation {
        id: pressAnim

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "bgColor"
                from: root.color
                to: "white"
                duration: 200
            }
            ColorAnimation {
                target: root
                property: "fgColor"
                from: root.border.color
                to: Qt.rgba(0.1, 0.1, 0.1, 1.0)
                duration: 200
            }
        }

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "bgColor"
                from: "white"
                to: "transparent"
                duration: 200
            }
            ColorAnimation {
                target: root
                property: "fgColor"
                from: Qt.rgba(0.1, 0.1, 0.1, 1.0)
                to: Qt.rgba(0.8, 0.8, 0.8, 1.0)
                duration: 200
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.text
        color: fgColor
    }

    Shortcut {
        sequence: shortcut
        onActivated: {
            pressAnim.start();
            root.clicked();
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPressed: root.state = "pressed"
        onReleased: {
            root.state = "released";
            root.clicked();
        }

        onEntered: root.state = "hovered"
        onExited: root.state = "released"
    }
}
