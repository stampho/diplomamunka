import QtQuick 2.6

Item {
    id: root

    SystemPalette {
        id: palette
    }

    default property alias contents: content.data
    property int pos: 0
    property int handleSize: 15
    property int paddingSize: 5
    property int orientation: Qt.Horizontal
    property color color: palette.window

    function isHorizontal() {
        return root.orientation == Qt.Horizontal
    }

    property real p: isHorizontal() ? y : x
    property real size: isHorizontal() ? height : width

    Binding {
        target: root
        property: isHorizontal() ? "y" : "x"
        value: p
    }

    Binding {
        target: root
        property: isHorizontal() ? "height" : "width"
        value: size
    }

    state: "closed"

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; p: pos }
            PropertyChanges { target: handleArrow; rotation: 180 }
        },
        State {
            name: "closed"
            PropertyChanges { target: root; p: pos - size + handleSize }
            PropertyChanges { target: handleArrow; rotation: 0 }
        }
    ]

    transitions: [
        Transition {
            ParallelAnimation {
                PropertyAnimation {
                    target: root; property: "p"
                    easing.type: "InBack"
                    duration: 300
                }

                PropertyAnimation {
                    target: handleArrow; property: "rotation"
                    easing.type: "InCubic"
                    duration: 300
                }
            }
        }
    ]

    Rectangle {
        id: padding
        width: root.isHorizontal() ? root.width : root.paddingSize
        height: root.isHorizontal() ? root.paddingSize : root.height

        anchors.top: root.top
        anchors.left: root.left

        color: root.color
    }

    Rectangle {
        id: content
        width: root.isHorizontal() ? root.width : root.width - root.handleSize - root.paddingSize
        height: root.isHorizontal() ? root.height - root.handleSize - root.paddingSize : root.height

        anchors.top: root.isHorizontal() ? padding.bottom : root.top
        anchors.left: root.isHorizontal() ? root.left : padding.right

        color: root.color
    }

    Rectangle {
        id: handle
        width: root.isHorizontal() ? root.width : root.handleSize
        height: root.isHorizontal() ? root.handleSize : root.height

        anchors.bottom: root.bottom
        anchors.right: root.right

        color: root.color
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.state = (Math.round(root.p) < 0)  ? "opened" : "closed"
            }
        }

        Canvas {
            id: handleArrow

            antialiasing:  true
            anchors.centerIn: parent

            width: root.isHorizontal() ? 14 : parent.width - 6
            height: root.isHorizontal() ? parent.height - 6 : 14

            onPaint: {
                var ctx = getContext("2d")

                ctx.strokeStyle = Qt.darker(root.color)
                ctx.fillStyle = Qt.darker(root.color)
                ctx.lineWidth = 1
                ctx.lineJoin = "round"

                if (root.isHorizontal()) {
                    ctx.moveTo(width / 2, height)
                    ctx.lineTo(0, 0)
                    ctx.lineTo(width, 0)
                } else {
                    ctx.moveTo(width, height / 2)
                    ctx.lineTo(0, 0)
                    ctx.lineTo(0, height)
                }

                ctx.closePath()
                ctx.fill()
            }
        }
    }
}
