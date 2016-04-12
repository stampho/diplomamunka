import QtQuick 2.6

Rectangle {
    id: root

    property string text: ""
    property bool enabled: true
    property string shortcut: ""
    signal clicked()

    SystemPalette {
        id: palette
    }

    property color bgColor: palette.window
    property color fgColor: "#111111"
    property color borderColor: Qt.darker(bgColor, 2.0)

    color: bgColor
    border.color: borderColor
    border.width: 0
    radius: 5

    state: "released"

    states: [
        State {
            name: "released"
            PropertyChanges { target: root; color: bgColor }
            PropertyChanges { target: root; border.width: 0 }
        },
        State {
            name: "pressed"
            PropertyChanges { target: root; color: Qt.darker(bgColor, 1.5) }
            PropertyChanges { target: root; border.width: 1 }
        },
        State {
            name: "hovered"
            PropertyChanges { target: root; color: bgColor }
            PropertyChanges { target: root; border.width: 1 }
        }
    ]

    SequentialAnimation {
        id: pressAnim

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "color"
                from: bgColor
                to: Qt.darker(bgColor, 1.5)
                duration: 200
            }

            PropertyAnimation {
                target: root
                property: "border.width"
                from: 0
                to: 1
                duration: 200
            }
        }

        ParallelAnimation {
            ColorAnimation {
                target: root
                property: "color"
                from: Qt.darker(bgColor, 1.5)
                to: bgColor
                duration: 200
            }

            PropertyAnimation {
                target: root
                property: "border.width"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    Text {
        anchors.centerIn: root
        color: root.enabled ? fgColor : Qt.lighter(fgColor, 10)
        text: root.text
        font.bold: true
    }

    Shortcut {
        sequence: shortcut
        enabled: root.enabled
        onActivated: {
            pressAnim.start()
            clicked()
        }
    }

    MouseArea {
        anchors.fill: root
        enabled: root.enabled
        hoverEnabled: true

        onPressed: root.state = "pressed"

        onReleased: {
            root.state = "released"
            root.clicked()
        }

        onEntered: root.state = "hovered"
        onExited: root.state = "released"
    }
}
