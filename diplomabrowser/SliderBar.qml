import QtQuick 2.6

// TODO(pvarga): Rename this: SliderBar -> SliderPanel
Item {
    id: root

    SystemPalette { id: palette }

    default property alias contents: content.data
    property int pos: 0
    property int handleSize: 15
    property int marginSize: 5
    property int orientation: Qt.Horizontal
    property int minSize: 0
    property color color: palette.window

    function isHorizontal() {
        return root.orientation == Qt.Horizontal;
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
            PropertyChanges { target: content; size: root.size - root.marginSize - root.handleSize }
            PropertyChanges { target: content; marginSize: 0 }
        },
        State {
            name: "closed"
            PropertyChanges { target: root; p: pos - size + minSize + handleSize }
            PropertyChanges { target: handleArrow; rotation: 0 }
            PropertyChanges { target: content; size: root.minSize - root.marginSize }
            PropertyChanges { target: content; marginSize: root.minSize ? root.size - root.minSize - root.handleSize : 0 }
        }
    ]

    // TODO(pvarga): rework animation: in and out. See SettingsPanel.qml
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

                PropertyAnimation {
                    target: content; property: "size"
                    easing.type: "InBack"
                    duration: 300
                }

                PropertyAnimation {
                    target: content; property: "marginSize"
                    easing.type: "InBack"
                    duration: 300
                }
            }
        }
    ]

    Rectangle {
        id: content

        property real size: root.size - root.marginSize - root.handleSize
        property int marginSize: 0

        width: root.isHorizontal() ? root.width : content.size
        height: root.isHorizontal() ? content.size : root.height

        anchors.top: root.top
        anchors.topMargin: root.isHorizontal() ? root.marginSize + content.marginSize : 0
        anchors.left: root.left
        anchors.leftMargin: root.isHorizontal() ? 0 : root.marginSize + content.marginSize

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
            onClicked: root.state = (Math.round(root.p) < 0)  ? "opened" : "closed"
        }

        Canvas {
            id: handleArrow

            antialiasing:  true
            anchors.centerIn: parent

            width: root.isHorizontal() ? 14 : parent.width - 6
            height: root.isHorizontal() ? parent.height - 6 : 14

            onPaint: {
                var ctx = getContext("2d");

                ctx.strokeStyle = Qt.darker(root.color);
                ctx.fillStyle = Qt.darker(root.color);
                ctx.lineWidth = 1;
                ctx.lineJoin = "round";

                if (root.isHorizontal()) {
                    ctx.moveTo(width / 2, height);
                    ctx.lineTo(0, 0);
                    ctx.lineTo(width, 0);
                } else {
                    ctx.moveTo(width, height / 2);
                    ctx.lineTo(0, 0);
                    ctx.lineTo(0, height);
                }

                ctx.closePath();
                ctx.fill();
            }
        }
    }
}
