import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtWebEngine 1.3
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Diploma Browser")

    property WebEngineView currentWebEngineView: null

    function createWebEngineView() {
        var webEngineView = Qt.createQmlObject("
                import QtQuick 2.5\n
                import QtWebEngine 1.3\n
                WebEngineView {\n
                    anchors.fill: parent
                }\n
            ", webFlickable.contentItem)

        webEngineView.loadingChanged.connect(function(loadRequest){
                if (!urlBar.lock && loadRequest.status == WebEngineView.LoadSucceededStatus)
                    urlBar.state = "closed"

                if (!urlBar.lock && loadRequest.status == WebEngineView.LoadStartedStatus)
                    urlBar.state = "opened"
            })

        return webEngineView
    }

    Settings {
        id: appSettings

        property alias lockUrlBar: lockUrlBar.checked
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: "Ctrl+l"
                onTriggered: {
                    urlBar.state = "opened"
                    addressBar.forceActiveFocus()
                }
            }
            MenuItem {
                text: qsTr("&Quit")
                shortcut: "Ctrl+q"
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("View")
            MenuItem {
                id: lockUrlBar
                text: qsTr("&Lock URL Bar")
                checkable: true
                checked: urlBar.lock
            }
        }
    }

    SliderBar {
        id: urlBar
        pos: parent.y
        width: parent.width - 4
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter

        orientation: Qt.Horizontal

        property bool lock: appSettings.lockUrlBar

        RowLayout {
            anchors.fill: parent
            spacing: 2

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: currentWebEngineView && currentWebEngineView.canGoBack
                text: "<"

                shortcut: "Ctrl+["
                onClicked: currentWebEngineView.goBack()
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                enabled: currentWebEngineView && currentWebEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: currentWebEngineView.goForward()
            }

            AddressBar {
                id: addressBar
                Layout.fillWidth: true

                progress: currentWebEngineView ? currentWebEngineView.loadProgress : -1
                iconUrl: currentWebEngineView ? currentWebEngineView.icon : ""
                pageUrl: currentWebEngineView ? currentWebEngineView.url : ""

                onAccepted: {
                    if (!currentWebEngineView)
                        currentWebEngineView = createWebEngineView()
                    currentWebEngineView.url = addressUrl
                }
            }

            BrowserButton {
                width: height
                height: parent.height - 4
                text: currentWebEngineView && currentWebEngineView.loading ? "X" : "R"
                enabled: currentWebEngineView

                shortcut: "Ctrl+r"
                onClicked: currentWebEngineView && currentWebEngineView.loading ? currentWebEngineView.stop() : currentWebEngineView.reload()
            }
        }
    }

    SliderBar {
        id: tabBar

        pos: parent.x
        width: 250
        minSize: 80
        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom

        orientation: Qt.Vertical

        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: 5

            color: "white"
            radius: 8

            Image {
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter;
                width: 48; height: 48
                sourceSize: Qt.size(width, height)
                source: currentWebEngineView ? currentWebEngineView.icon : ""
                visible: tabBar.state == "closed"
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5

                height: 30
                border.width: 1
                radius: 4

                visible: tabBar.state == "opened"

                RowLayout {
                    anchors.fill: parent
                    anchors.verticalCenter:  parent.verticalCenter
                    anchors.leftMargin: 5

                    Image {
                        width: 24; height: 24;
                        sourceSize: Qt.size(width, height)
                        source: currentWebEngineView ? currentWebEngineView.icon : ""
                    }

                    Text {
                        Layout.fillWidth: true
                        text: currentWebEngineView ? currentWebEngineView.title : ""
                        font.pixelSize: 16
                        clip: true
                    }
                }
            }
        }
    }

    Flickable {
        id: webFlickable

        anchors.top: urlBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: tabBar.right
        anchors.right: parent.right
    }

    Component.onCompleted: {
        currentWebEngineView = createWebEngineView()
        currentWebEngineView.url = Qt.resolvedUrl("http://www.google.com")
    }
}
