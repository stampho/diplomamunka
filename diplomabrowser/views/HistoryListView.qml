import QtQuick 2.6
import QtQuick.Layouts 1.1
import "../controls"

ListView {
    id: root

    property real size: 50
    signal selected(int offset)

    spacing: 5
    clip: true

    states: [
        State {
            name: "compact"
            PropertyChanges { target: root; delegate: compactDelegate }
            PropertyChanges { target: root; size: 50 }
        },
        State {
            name: "wide"
            PropertyChanges { target: root; delegate: wideDelegate }
            PropertyChanges { target: root; size: 30 }
        }
    ]

    Rectangle {
        anchors.fill: parent
        z: root.z - 1

        color: "white"
        radius: 8
    }

    Rectangle {
        anchors.fill: parent
        z: root.z + 3

        color: "transparent"
        radius: 8

        border.color: "lightgray"
        width: 1

        clip: true

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -root.size / 2 - 2
            width: root.width
            height: 2
            border.width: 1
            z: parent.z - 1
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: root.size / 2 + 2
            width: root.width
            height: 2
            border.width: 1
            z: parent.z - 1
        }
    }

    preferredHighlightBegin: root.height/2 - root.size/2
    preferredHighlightEnd: root.height/2 + root.size/2
    highlightRangeMode: ListView.StrictlyEnforceRange

    property Component compactDelegate: Component {
        CompactEntry {
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            z: root.z + 1
            enableClose: false

            iconUrl: icon ? icon : ""
            size: ListView.isCurrentItem ? root.size : 30

            onClicked: {
                if (currentIndex == index)
                    return;
                root.currentIndex = index;
                root.selected(offset);
            }
        }
    }

    property Component wideDelegate : Component {
        WideEntry {
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            z: root.z + 1
            enableClose: false

            iconUrl: icon ? icon : ""
            pageTitle: title ? title : ""

            onClicked: {
                if (currentIndex == index)
                    return;
                root.currentIndex = index;
                root.selected(offset);
            }
        }
    }
}
