import QtQuick 2.6

Rectangle {
    id: root

    property string leftText: ""
    property string leftTextColor: "white"
    property string rightText: ""
    property string rightTextColor: "black"

    signal clicked()

    color: "transparent"
    border.width: 1
    border.color: Qt.darker("gray", 2.0)
    radius: 6

    states: [
        State {
            name: "left"
            PropertyChanges { target: left; color: border.color }
            PropertyChanges { target: root; leftTextColor: "white" }
            PropertyChanges { target: right; color: "lightgray" }
            PropertyChanges { target: root; rightTextColor: "black" }
        },
        State {
            name: "right"
            PropertyChanges { target: left; color: "lightgray" }
            PropertyChanges { target: root; leftTextColor: "black" }
            PropertyChanges { target: right; color: border.color }
            PropertyChanges { target: root; rightTextColor: "white" }
        }
    ]

    Item {
        id: left

        anchors.left: parent.left
        property color color: root.border.color

        z: parent.z - 1
        width: parent.width / 2
        height: parent.height

        Rectangle {
            id: l
            anchors.left: parent.left
            width: parent.width / 2
            height: parent.height
            color: parent.color
            radius: root.radius
        }

        Rectangle {
            anchors.left: l.right
            anchors.leftMargin: -8
            width: parent.width / 2 + 8
            height: parent.height
            color: parent.color
        }

        Text {
            anchors.centerIn: parent
            text: root.leftText
            color: root.leftTextColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.state = "left";
                root.clicked();
            }
        }
    }

    Item {
        id: right

        anchors.right: parent.right
        property color color: "lightgray"

        z: parent.z - 1
        width: parent.width / 2
        height: parent.height

        Rectangle {
            id: r
            anchors.right: parent.right
            width: parent.width / 2
            height: parent.height
            color: parent.color
            radius: root.radius
        }

        Rectangle {
            anchors.right: r.left
            anchors.rightMargin: -8
            width: parent.width / 2 + 8
            height: parent.height
            color: parent.color
        }

        Text {
            anchors.centerIn: parent
            text: root.rightText
            color: root.rightTextColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.state = "right";
                root.clicked();
            }
        }
    }
}
