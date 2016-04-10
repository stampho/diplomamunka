import QtQuick 2.6
import QtQuick.Controls 1.5
import QtWebEngine 1.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Diploma Browser")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    SystemPalette {
        id: palette
    }

    Rectangle {
        id: urlBar

        width: parent.width
        height: 50

        property int handleHeight: 15

        y: parent.y - height + handleHeight

        Behavior on y {
            NumberAnimation {
                easing.type: "InBack"
                duration: 300
            }
        }


        Rectangle {
            width: parent.width
            height: parent.height - parent.handleHeight

            anchors.top: parent.top

            TextField {
                anchors.fill: parent
                text: webEngineView && webEngineView.url
                onAccepted: webEngineView.url = utils.fromUserInput(text)
            }
        }

        Rectangle {
            width: parent.width
            height: parent.handleHeight

            anchors.bottom: parent.bottom

            color: palette.window
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var ypos = Math.round(urlBar.y)
                    if (ypos < 0)
                        urlBar.y = 0
                    else
                        urlBar.y = urlBar.parent.y - urlBar.height + height

                    handleArrow.rotation += 180
                }
            }

            Canvas {
                id: handleArrow

                antialiasing:  true
                anchors.centerIn: parent

                width: 20
                height: parent.height - 4

                Behavior on rotation {
                    NumberAnimation {
                        easing.type: "InCubic"
                        duration: 300
                    }
                }

                onPaint: {
                    var ctx = getContext("2d")

                    ctx.strokeStyle = Qt.darker(palette.window)
                    ctx.fillStyle = Qt.darker(palette.window)
                    ctx.lineWidth = 1
                    ctx.lineJoin = "round"

                    ctx.moveTo(width / 2, height )
                    ctx.lineTo(0, 0)
                    ctx.lineTo(width, 0)
                    ctx.closePath()

                    ctx.fill()
                }

            }
        }
    }

    WebEngineView {
        id: webEngineView
        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        url: utils.fromUserInput("http://www.google.com")
    }
}
