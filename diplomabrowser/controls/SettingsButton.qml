import QtQuick 2.6

Button {
    releasedBgColor: "transparent"
    releasedFgColor: Qt.rgba(0.8, 0.8, 0.8, 1.0)
    pressedBgColor: "white"
    pressedFgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    hoveredBgColor: "transparent"
    hoveredFgColor: "white"
    disabledFgColor: Qt.darker(releasedFgColor, 2.5)
    disabledBrColor: Qt.darker(releasedBrColor, 2.5)
}
