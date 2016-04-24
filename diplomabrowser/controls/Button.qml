import QtQuick 2.6

Rectangle {
    id: root

    property color releasedBgColor: "white"
    property color releasedFgColor: "black"
    property color releasedBrColor: releasedFgColor
    property color pressedBgColor: "black"
    property color pressedFgColor: "white"
    property color pressedBrColor: pressedFgColor
    property color hoveredBgColor: "white"
    property color hoveredFgColor: "black"
    property color hoveredBrColor: hoveredFgColor

    property string text: ""
    property string shortcut: ""
    property bool enabled: true

    property color bgColor: releasedBgColor
    property color fgColor: releasedFgColor
    property color brColor: releasedBrColor

    signal clicked()

    color: bgColor
    border.color: brColor

    border.width: 1
    radius: 4

    state: "released"
    states: [
        State {
            name: "released"
            PropertyChanges { target: root; bgColor: releasedBgColor }
            PropertyChanges { target: root; fgColor: releasedFgColor }
            PropertyChanges { target: root; brColor: releasedBrColor }
        },
        State {
            name: "pressed"
            PropertyChanges { target: root; bgColor: pressedBgColor }
            PropertyChanges { target: root; fgColor: pressedFgColor }
            PropertyChanges { target: root; brColor: pressedBrColor }
        },
        State {
            name: "hovered"
            PropertyChanges { target: root; bgColor: hoveredBgColor }
            PropertyChanges { target: root; fgColor: hoveredFgColor }
            PropertyChanges { target: root; brColor: hoveredBrColor }
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
        color: root.enabled ? fgColor : Qt.lighter(fgColor, 6.0)
        font.bold: true
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
        anchors.fill: root
        enabled: root.enabled
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
