import QtQuick 2.6

Rectangle {
    id: root

    default property alias contents: content.data
    property int handleHeight: 15
    property int paddingTop: 5

    function open() {
        if (Math.round(root.y) == 0)
            return

        y = 0;
        handleArrow.rotation += 180
    }

    function close() {
        if (Math.round(root.y) != 0)
            return
        y = parent.y - height + handleHeight
        handleArrow.rotation += 180
    }

    y: parent.y - height + handleHeight

    SystemPalette {
        id: palette
    }

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

        color: palette.window
    }

    Rectangle {
        id: content
        width: root.width
        height: root.height - root.handleHeight - root.paddingTop

        anchors.top: padding.bottom

        color: palette.window
    }

    Rectangle {
        width: root.width
        height: root.handleHeight

        anchors.bottom: root.bottom

        color: palette.window
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var ypos = Math.round(root.y)
                if (ypos < 0)
                    root.open()
                else
                    root.close()
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

                ctx.strokeStyle = Qt.darker(palette.window)
                ctx.fillStyle = Qt.darker(palette.window)
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
