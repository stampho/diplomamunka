import QtQuick 2.6

Button {
    SystemPalette { id: palette }

    releasedBgColor: palette.window
    releasedFgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    releasedBrColor: "transparent"
    pressedBgColor: Qt.darker(releasedBgColor, 1.5)
    pressedFgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    pressedBrColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    hoveredBgColor: palette.window
    hoveredFgColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
    hoveredBrColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
}
