import QtQuick 2.6

Rectangle {
    anchors.left: parent ? parent.left : undefined
    anchors.leftMargin: 5
    anchors.right: parent ? parent.right : undefined
    anchors.rightMargin: 5

    color: "transparent"
    width: 50; height: 50

    border.width: 1
    border.color: "black"
    radius: 8
}
