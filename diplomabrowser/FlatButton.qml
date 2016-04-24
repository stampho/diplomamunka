import QtQuick 2.6

Rectangle {
    id: root

    property color releasedBgColor: "transparent"
    property color releasedFgColor: Qt.rgba(0.8, 0.8, 0.8, 1.0)
    property color pressedBgColor: "white"
    property color pressedFgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    property color hoveredBgColor: "transparent"
    property color hoveredFgColor: "white"

    property string text: ""
    property string shortcut: ""
    property bool enabled: true

    property color bgColor: releasedBgColor
    property color fgColor: releasedFgColor

    signal clicked()

    color: bgColor
    border.color: fgColor

    border.width: 1
    radius: 5

    state: "released"
    states: [
        State {
            name: "released"
            PropertyChanges { target: root; bgColor: releasedBgColor }
            PropertyChanges { target: root; fgColor: releasedFgColor }
        },
        State {
            name: "pressed"
            PropertyChanges { target: root; bgColor: pressedBgColor }
            PropertyChanges { target: root; fgColor: pressedFgColor }
        },
        State {
            name: "hovered"
            PropertyChanges { target: root; bgColor: hoveredBgColor }
            PropertyChanges { target: root; fgColor: hoveredFgColor }
        }
    ]

    SequentialAnimation {
        id: pressAnim

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "bgColor"
                from: root.releasedBgColor
                to: root.pressedBgColor
                duration: 200
            }
            ColorAnimation {
                target: root
                property: "fgColor"
                from: root.releasedFgColor
                to: root.pressedFgColor
                duration: 200
            }
        }

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "bgColor"
                from: root.pressedBgColor
                to: root.releasedBgColor
                duration: 200
            }
            ColorAnimation {
                target: root
                property: "fgColor"
                from: root.pressedFgColor
                to: root.releasedFgColor
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
        enabled: root.enabled
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
