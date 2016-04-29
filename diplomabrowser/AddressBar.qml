import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root

    property int progress: 0
    property url iconUrl: ""
    property url pageUrl: ""

    signal accepted(url addressUrl)

    SystemPalette { id: palette }

    height: addressField.height
    color: "white"
    radius: 4

    onActiveFocusChanged: {
        if (activeFocus)
            addressField.forceActiveFocus();
    }

    Rectangle {
        width: addressField.width / 100 * root.progress
        height: root.height

        visible: root.progress < 100

        color: "#b6dca6"
        radius: root.radius
    }

    TextField {
        id: addressField
        anchors.fill: parent
        text: root.pageUrl

        Image {
            id: icon
            anchors.verticalCenter: addressField.verticalCenter
            x: 5; z: parent.z + 1
            width: 16; height: 16
            sourceSize: Qt.size(width, height)
            source: root.iconUrl
            visible: root.progress == 100
        }

        Text {
            text: root.progress < 0 ? "" : root.progress + "%"
            x: 5; z: parent.z + 1
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 10

            visible: root.progress < 100
        }

        style: TextFieldStyle {
            padding.left: 30

            background: Rectangle {
                color: "transparent"
                border.color: Qt.darker(palette.window, 2.0)
                border.width: 1
                radius: root.radius
            }
        }

        onActiveFocusChanged: activeFocus ? selectAll() : deselect()
        onAccepted: root.accepted(utils.fromUserInput(text))
    }
}
