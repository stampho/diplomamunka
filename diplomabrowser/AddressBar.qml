import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root

    property int progress: 0
    property url iconUrl: ""
    property url pageUrl: ""

    signal accepted(url addressUrl)

    SystemPalette {
        id: palette
    }

    height: addressField.height

    onActiveFocusChanged: {
        if (activeFocus == true)
            addressField.forceActiveFocus()
    }

    Rectangle {
        width: addressField.width / 100 * root.progress
        height: addressField.height

        visible: root.progress < 100

        color: "#b6dca6"
        radius: 4
    }

    TextField {
        id: addressField
        anchors.fill: parent

        Image {
            anchors.verticalCenter: addressField.verticalCenter;
            x: 5; z: parent.z + 1
            width: 16; height: 16
            sourceSize: Qt.size(width, height)
            source: root.iconUrl
            visible: root.progress == 100
        }

        Text {
            text: root.progress + "%"
            x: 5; z: parent.z + 1
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter

            visible: root.progress < 100
        }

        style: TextFieldStyle {
            padding.left: 30

            background: Rectangle {
                color: root.progress < 100 ? "transparent" : Qt.lighter(palette.window)
                border.color: Qt.darker(palette.window, 2.0)
                border.width: 1
                radius: 4
            }
        }

        onActiveFocusChanged: {
            if (activeFocus)
                selectAll()
            else
                deselect()
        }

        text: root.pageUrl
        onAccepted: root.accepted(utils.fromUserInput(text))
    }
}
