import QtQuick 2.6
import QtQuick.Layouts 1.1

ListView {
    id: root

    signal selected(int offset)

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

    highlightFollowsCurrentItem: true
    highlight: HighlightItem { z: root.z + 2 }

    property Component compactDelegate: Component {
        CompactEntry {
            z: root.z + 1

            iconUrl: icon

            onClicked: {
                root.currentIndex = index
                root.selected(offset)
            }
        }
    }

    property Component wideDelegate : Component {
        WideEntry {
            z: root.z + 1

            iconUrl: icon
            pageTitle: title

            onClicked: {
                root.currentIndex = index
                root.selected(offset)
            }
        }
    }
}
