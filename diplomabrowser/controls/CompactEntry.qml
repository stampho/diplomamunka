import QtQuick 2.6
import QtGraphicalEffects 1.0

Rectangle {
    id: root

    property url iconUrl: ""
    property real size: 50
    property bool enableClose: true
    signal clicked()
    signal closed()

    width: size
    height: size
    color: "white"
    radius: 8

    Rectangle {
        id: mask
        anchors.fill: parent
        anchors.margins: 1
        radius: parent.radius
        clip: true
        visible: false
    }

    Image {
        id: icon
        anchors.centerIn: parent
        width: size - 2; height: size - 2
        sourceSize: Qt.size(width, height)
        source: iconUrl
        visible: false
    }

    OpacityMask {
        anchors.fill: mask
        source: icon
        maskSource: mask
        visible: icon.source != ""
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()

        hoverEnabled: root.enableClose

        onEntered: closeButton.visible = enableClose
        onExited: closeButton.visible = false

        CloseButton {
            id: closeButton

            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4

            width: 12
            height: 12

            visible: false
            onClicked: root.closed()
        }
    }
}
