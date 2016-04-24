import QtQuick 2.6
import QtQuick.Layouts 1.1

Rectangle {
    id: root

    property url iconUrl: ""
    property string pageTitle: ""
    property bool enableClose: true
    signal clicked()
    signal closed()

    width: parent ? parent.width - 10 : 0
    height: 30
    color: "white"
    radius: 8

    RowLayout {
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5

        Image {
            width: 16; height: 16;
            sourceSize: Qt.size(width, height)
            source: iconUrl
        }
        Text {
            Layout.fillWidth: true
            text: pageTitle
            font.pixelSize: 16
            clip: true
        }
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
            anchors.verticalCenter: parent.verticalCenter

            width: height
            height: parent.height - 12
            radius: 4

            releasedBgColor: Qt.rgba(1.0, 1.0, 1.0, 0.6)
            releasedFgColor: Qt.rgba(0.0, 0.0, 0.0, 0.6)
            hoveredBgColor: Qt.rgba(1.0, 1.0, 1.0, 0.6)
            hoveredFgColor: "black"
            pressedBgColor: Qt.rgba(0.0, 0.0, 0.0, 0.8)
            pressedFgColor: "white"

            visible: false
            text: "X"

            onClicked: root.closed()
        }
    }
}
