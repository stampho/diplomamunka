import QtQuick 2.6

Rectangle {
    id: root

    property url iconUrl: ""
    signal clicked()

    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5

    height: 50
    color: "white"
    radius: 8

    Image {
        anchors.centerIn: parent
        width: 48; height: 48
        sourceSize: Qt.size(width, height)
        source: iconUrl
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
