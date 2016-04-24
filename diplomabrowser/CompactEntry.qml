import QtQuick 2.6

Rectangle {
    id: root

    property url iconUrl: ""
    property real size: 50
    property bool enableClose: true
    signal clicked()

    width: size
    height: size
    color: "white"
    radius: 8

    Image {
        anchors.centerIn: parent
        width: size - 2; height: size - 2
        sourceSize: Qt.size(width, height)
        source: iconUrl
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()

        hoverEnabled: root.enableClose

        onEntered: closeButton.visible = enableClose
        onExited: closeButton.visible = false

        FlatButton {
            id: closeButton

            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4

            width: 12
            height: 12
            radius: 4

            releasedBgColor: Qt.rgba(1.0, 1.0, 1.0, 0.6)
            releasedFgColor: Qt.rgba(0.0, 0.0, 0.0, 0.6)
            hoveredBgColor: Qt.rgba(1.0, 1.0, 1.0, 0.6)
            hoveredFgColor: "black"
            pressedBgColor: Qt.rgba(0.0, 0.0, 0.0, 0.8)
            pressedFgColor: "white"

            visible: false
            text: "X"
        }
    }
}
