import QtQuick 2.6

Rectangle {
    id: root

    property url iconUrl: ""
    property real size: 50
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
    }
}
