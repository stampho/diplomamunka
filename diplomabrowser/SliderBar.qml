import QtQuick 2.6

Rectangle {
    id: root

    SystemPalette {
        id: palette
    }

    default property alias contents: content.data
    property int pos: 0
    property int handleHeight: 15
    property int paddingTop: 5

    color: palette.window
    state: "closed"

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; y: pos }
            PropertyChanges { target: handleArrow; rotation: 0 }
        },
        State {
            name: "closed"
            PropertyChanges { target: root; y: pos - height + handleHeight }
            PropertyChanges { target: handleArrow; rotation: 180 }
        }
    ]


    Behavior on y {
        NumberAnimation {
            easing.type: "InBack"
            duration: 300
        }
    }

    Rectangle {
        id: padding
        width: root.width
        height: root.paddingTop

        anchors.top: root.top

        color: root.color
    }

    Rectangle {
        id: content
        width: root.width
        height: root.height - root.handleHeight - root.paddingTop

        anchors.top: padding.bottom

        color: root.color
    }

    Rectangle {
        width: root.width
        height: root.handleHeight

        anchors.bottom: root.bottom

        color: root.color
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var ypos = Math.round(root.y)
                root.state = (ypos < 0) ? "opened" : "closed"
            }
        }

        Canvas {
            id: handleArrow

            antialiasing:  true
            anchors.centerIn: parent

            width: 14
            height: parent.height - 6

            Behavior on rotation {
                NumberAnimation {
                    easing.type: "InCubic"
                    duration: 300
                }
            }

            onPaint: {
                var ctx = getContext("2d")

                ctx.strokeStyle = Qt.darker(root.color)
                ctx.fillStyle = Qt.darker(root.color)
                ctx.lineWidth = 1
                ctx.lineJoin = "round"

                ctx.moveTo(width / 2, height )
                ctx.lineTo(0, 0)
                ctx.lineTo(width, 0)
                ctx.closePath()

                ctx.fill()
            }
        }
    }
}
