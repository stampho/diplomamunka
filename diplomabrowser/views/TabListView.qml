import QtQuick 2.6
import QtQuick.Layouts 1.1
import "../controls"

ListView {
    id: root

    signal selected(int index)
    signal closed(int index)

    spacing: 5
    clip: true

    states: [
        State {
            name: "compact"
            PropertyChanges { target: root; delegate: compactDelegate }
        },
        State {
            name: "wide"
            PropertyChanges { target: root; delegate: wideDelegate }
        }
    ]

    add: Transition {
        PropertyAnimation {
            properties: "opacity, scale"
            from: 0.0
            to: 1.0
            duration: 400
        }
        PropertyAnimation {
            target: highlightItem
            properties: "opacity, scale"
            from: 0.0
            to: 1.0
            duration: 400
        }
    }

    addDisplaced: Transition {
        PropertyAnimation {
            property: "y"
            duration: 400
        }
    }

    remove: Transition {
        PropertyAnimation {
            properties: "opacity, scale"
            from: 1.0
            to: 0.0
            duration: 400
        }
    }

    removeDisplaced: Transition {
        PropertyAnimation {
            property: "y"
            duration: 400
        }
    }

    highlightFollowsCurrentItem: true
    highlight: Rectangle {
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
        z: root.z + 2
        color: "transparent"

        border.width: 2
        border.color: "black"
        radius: 8
    }

    property Component compactDelegate: Component {
        CompactEntry {
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            z: root.z + 1

            border.color: "lightgray"
            border.width: 1

            iconUrl: webEngineView ? webEngineView.icon : ""

            onClicked: root.selected(index)
            onClosed: root.closed(index)
        }
    }

    property Component wideDelegate : Component {
        WideEntry {
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            z: root.z + 1

            border.color: "lightgray"
            border.width: 1

            iconUrl: webEngineView ? webEngineView.icon : ""
            pageTitle: webEngineView ? webEngineView.title : ""

            onClicked: root.selected(index)
            onClosed: root.closed(index)
        }
    }
}
