import QtQuick 2.6
import QtQuick.Layouts 1.1

Rectangle {
    id: root

    property url iconUrl: ""
    property string pageTitle: ""
    signal clicked()

    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5

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
    }
}
