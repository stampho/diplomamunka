import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtWebEngine 1.3
import Qt.labs.settings 1.0

import "controls"
import "models"
import "views"

ApplicationWindow {
    visible: true
    width: 1300
    height: 800
    title: qsTr("Diploma Browser")

    property alias currentWebEngineView: viewListModel.currentWebEngineView

    Settings {
        id: appSettings

        property alias lockNavigationPanel: lockNavigationPanel.checked
        property alias autoLoadIconsForPage: autoLoadIconsForPage.checked
        property alias touchIconsEnabled: touchIconsEnabled.checked
        property alias autoLoadImages: autoLoadImages.checked
        property alias javaScriptEnabled: javaScriptEnabled.checked

        property alias homeUrl: settingsPanel.homeUrl
        property alias locale: settingsPanel.locale
    }

    WebEngineViewListModel {
        id: viewListModel

        wrapper: webView

        onCreated: {
            webEngineView.settings.autoLoadIconsForPage = Qt.binding(function() { return appSettings.autoLoadIconsForPage; });
            webEngineView.settings.touchIconsEnabled = Qt.binding(function() { return appSettings.touchIconsEnabled; });
            webEngineView.settings.autoLoadImages = Qt.binding(function() { return appSettings.autoLoadImages; });
            webEngineView.settings.javaScriptEnabled = Qt.binding(function() { return appSettings.javaScriptEnabled; });

            if (webEngineView.url == "")
                webEngineView.url = appSettings.homeUrl;

            webEngineView.loadingChanged.connect(function(loadRequest){
                    if (!navigationPanel.lock && loadRequest.status == WebEngineView.LoadSucceededStatus)
                        navigationPanel.state = "closed";

                    if (!navigationPanel.lock && loadRequest.status == WebEngineView.LoadStartedStatus)
                        navigationPanel.state = "opened";

                    if (loadRequest.status != WebEngineView.LoadStartedStatus)
                        historyListView.currentIndex = currentWebEngineView ? currentWebEngineView.navigationHistory.backItems.rowCount() : -1;
                })
        }

        onSelected: {
            tabListView.currentIndex = index;
            historyListView.currentIndex = currentWebEngineView ? currentWebEngineView.navigationHistory.backItems.rowCount() : -1;
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: "Ctrl+l"
                onTriggered: {
                    navigationPanel.state = "opened";
                    addressBar.forceActiveFocus();
                }
            }
            MenuItem {
                text: qsTr("New &Tab")
                shortcut: StandardKey.AddTab
                onTriggered: {
                    viewListModel.create(tabListView.currentIndex + 1);
                    viewListModel.select(tabListView.currentIndex + 1);
                    navigationPanel.state = "opened";
                    addressBar.forceActiveFocus();
                }
            }
            MenuItem {
                text: qsTr("&Close Tab")
                shortcut: StandardKey.Close
                onTriggered: viewListModel.close(tabListView.currentIndex);
            }
            MenuItem {
                text: qsTr("&Screenshot")
                shortcut: "Ctrl+s"
                onTriggered: {
                    if (!currentWebEngineView)
                        return;

                    Date.prototype.timestamp = function() {
                        var year = this.getFullYear().toString();
                        var month = (this.getMonth() + 1).toString();
                        var day = this.getDate().toString();
                        var hours = this.getHours().toString();
                        var mins = this.getMinutes().toString();
                        var secs = this.getSeconds().toString();

                        return year + (month[1] ? "" : "0" ) + month + (day[1] ? "" : "0") + day + "-" +
                                (hours[1] ? "" : "0") + hours + (mins[1] ? "" : "0") + mins + (secs[1] ? "" : "0") + secs;
                    }
                    var timestamp = new Date().timestamp();
                    var fileName = "webengineview-screen-" + timestamp + ".png";

                    currentWebEngineView.grabToImage(function(result) { result.saveToFile(fileName); });
                    console.log("Screenshot has been saved to " + fileName);
                }
            }

            MenuItem {
                text: qsTr("&Quit")
                shortcut: "Ctrl+q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("&Find")
                shortcut: "Ctrl+f"
                onTriggered: findBar.show()
            }
            MenuItem {
                text: qsTr("&Settings")
                shortcut: "Ctrl+,"
                onTriggered: settingsPanel.state = "shown"
            }
        }
    }

    SettingsPanel {
        id: settingsPanel

        anchors.centerIn: parent
        width: 600
        height: 400

        color: Qt.rgba(0.1, 0.1, 0.1, 0.95)
        border.color: "black"

        onStateChanged: (state == "hidden" && currentWebEngineView) ? currentWebEngineView.forceActiveFocus() : forceActiveFocus()

        property url homeUrl: appSettings.homeUrl
        property string locale: appSettings.locale

        onAccepted: {
            homeUrl = utils.fromUserInput(homeUrlField.text);
            if (locale != localeCombo.locale) {
                locale = localeCombo.locale;
                utils.setLocale(locale);
                settingsPanel.state = "confirm";
            } else
                settingsPanel.state = "hidden";
        }

        onCancelled: {
            homeUrlField.text = appSettings.homeUrl;
            localeCombo.locale = appSettings.locale;
            localeCombo.currentIndex = localeCombo.model.findLocale(locale);
            settingsPanel.state = "hidden";
        }

        onRestartRequest: {
            for (var i = 0; i < viewListModel.count; ++i)
                viewListModel.restart(i);
        }

        /* Appearance HEADER */
        Text {
            text: qsTr("Appearance")
            color: "white"
            font.bold: true
            font.pixelSize: 18
        }
        Rectangle {
            Layout.fillWidth: true
            height: 2
            border.width: 1
            border.color: "white"
        }
        Rectangle { height: 5 }

        /* Appearance CONTENT */
        ColumnLayout {
            Layout.fillWidth: true
            anchors.left: parent.left
            anchors.leftMargin: 10

            CheckBox {
                id: autoLoadIconsForPage
                text: qsTr("Enable Icons")
                checked: WebEngine.settings.autoLoadIconsForPage
                style: settingsPanel.checkBoxStyle
            }
            CheckBox {
                id: touchIconsEnabled
                text: qsTr("Enable Touch Icons")
                checked: WebEngine.settings.touchIconsEnabled
                style: settingsPanel.checkBoxStyle
                enabled: autoLoadIconsForPage.checked
            }
            CheckBox {
                id: autoLoadImages
                text: qsTr("Enable Images")
                checked: WebEngine.settings.autoLoadImages
                style: settingsPanel.checkBoxStyle
            }
            CheckBox {
                id: lockNavigationPanel
                text: qsTr("Lock Navigation Panel")
                checked: navigationPanel.lock
                style: settingsPanel.checkBoxStyle
            }
        }
        Rectangle { height: 15 }

        /* General HEADER */
        Text {
            text: qsTr("General")
            color: "white"
            font.bold: true
            font.pixelSize: 18
        }
        Rectangle {
            Layout.fillWidth: true
            height: 2
            border.width: 1
            border.color: "white"
        }
        Rectangle { height: 5 }

        /* General CONTENT */
        ColumnLayout {
            Layout.fillWidth: true
            anchors.left: parent.left
            anchors.leftMargin: 10

            Row {
                spacing: 10

                Text {
                    text: "Home:"
                    color: "white"
                    font.pixelSize: 16

                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    id: homeUrlField
                    text: appSettings.homeUrl

                    style: settingsPanel.textFieldStyle
                    width: 200
                    anchors.verticalCenter: parent.verticalCenter

                    onActiveFocusChanged: activeFocus ? selectAll() : deselect()
                }
                SettingsButton {
                    text: "Set Current URL"
                    onClicked: homeUrlField.text = currentWebEngineView.url

                    width: 120; height: homeUrlField.height
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Row {
                spacing: 10

                Text {
                    text: "Language:"
                    color: "white"
                    font.pixelSize: 16

                    anchors.verticalCenter: parent.verticalCenter
                }
                ComboBox {
                    id: localeCombo
                    anchors.verticalCenter: parent.verticalCenter
                    width: 200

                    model: LocaleListModel { }
                    textRole: "name"

                    property string locale: appSettings.locale
                    onCountChanged: currentIndex = model.findLocale(locale)
                    onCurrentIndexChanged: localeCombo.locale = model.get(currentIndex).locale
                }
            }
            CheckBox {
                id: javaScriptEnabled
                text: qsTr("Enable JavaScript")
                checked: WebEngine.settings.javascriptEnabled
                style: settingsPanel.checkBoxStyle
            }
        }
        Rectangle { height: 15 }
    }

    SliderPanel {
        id: navigationPanel
        pos: parent.y
        width: parent.width - 4
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        z: parent.z + 1

        orientation: Qt.Horizontal

        property bool lock: appSettings.lockNavigationPanel

        RowLayout {
            anchors.fill: parent
            spacing: 2

            BrowserButton {
                width: height
                height: parent.height - 10
                enabled: currentWebEngineView && currentWebEngineView.canGoBack
                text: "<"

                shortcut: "Ctrl+["
                onClicked: {
                    historyListView.currentIndex -= 1;
                    currentWebEngineView.goBack();
                    navigationAnimation.start();
                }
            }

            BrowserButton {
                width: height
                height: parent.height - 10
                enabled: currentWebEngineView && currentWebEngineView.canGoForward
                text: ">"

                shortcut: "Ctrl+]"
                onClicked: {
                    historyListView.currentIndex += 1;
                    currentWebEngineView.goForward();
                    navigationAnimation.start();
                }
            }

            AddressBar {
                id: addressBar
                Layout.fillWidth: true

                progress: (currentWebEngineView && currentWebEngineView.url != "") ? currentWebEngineView.loadProgress : -1
                iconUrl: currentWebEngineView ? currentWebEngineView.icon : ""
                pageUrl: currentWebEngineView ? currentWebEngineView.url : ""

                onAccepted: {
                    if (!currentWebEngineView) {
                        viewListModel.create();
                        viewListModel.select(viewListModel.count - 1);
                    }
                    currentWebEngineView.url = addressUrl;
                }
            }

            BrowserButton {
                width: height
                height: parent.height - 10
                text: currentWebEngineView && currentWebEngineView.loading ? "X" : "R"
                enabled: currentWebEngineView

                shortcut: "Ctrl+r"
                onClicked: currentWebEngineView && currentWebEngineView.loading ? currentWebEngineView.stop() : currentWebEngineView.reload()
            }
        }
    }

    SliderPanel {
        id: tabPanel

        pos: parent.x
        width: 250
        minSize: 70
        anchors.top: navigationPanel.bottom
        anchors.bottom: parent.bottom

        orientation: Qt.Vertical

        StackView {
            id: tabBarStack

            anchors.left: parent.left
            anchors.right: parent.right
            // FIXME(pvarga): Remove this workaround
            anchors.rightMargin: historyListView.visible && historyListView.state == "compact" ? 5 : 0
            anchors.top: parent.top
            anchors.bottom: tabControl.top

            clip: true
            initialItem: (tabSwitch.state == "left") ? tabListView : historyListView

            TabListView {
                id: tabListView
                visible: tabSwitch.state == "left"

                model: viewListModel
                state: (tabPanel.state == "closed") ? "compact" : "wide"

                onSelected: viewListModel.select(index)
                onClosed: viewListModel.close(index)
            }

            HistoryListView {
                id: historyListView
                visible: tabSwitch.state == "right"

                model: currentWebEngineView ? currentWebEngineView.navigationHistory.items : undefined
                state: (tabPanel.state == "closed") ? "compact" : "wide"

                onSelected: {
                    navigationAnimation.start();
                    currentWebEngineView.goBackOrForward(offset);
                }
            }

            delegate: StackViewDelegate {
                replaceTransition: StackViewTransition {
                    PropertyAnimation {
                        target: enterItem
                        property: "x"
                        from: (enterItem.model == viewListModel) ? -enterItem.width : enterItem.width
                        to: 0
                        duration: 300
                    }
                    PropertyAnimation {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: (exitItem.model == viewListModel) ? -exitItem.width : exitItem.width
                        duration: 300
                    }
                }
            }
        }

        Rectangle {
            id: tabControl

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 50
            color: "transparent"

            BrowserSwitch {
                id: tabSwitch

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10

                height: 20

                leftText: width > 60 ? "Tabs" : "T"
                rightText: width > 60 ? "History" : "H"

                state: "left"

                onClicked: tabBarStack.push({item: (state == "left") ? tabListView : historyListView, replace: true})
            }
        }
    }

    StackView {
        id: webView

        anchors.top: navigationPanel.bottom
        anchors.bottom: parent.bottom
        anchors.left: tabPanel.right
        anchors.right: parent.right

        clip: true

        delegate: StackViewDelegate {
            replaceTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: (enterItem.index < exitItem.index) ? -enterItem.height : enterItem.height
                    to: 0
                    duration: 300
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: (enterItem.index < exitItem.index) ? exitItem.height : -exitItem.height
                    duration: 300
                }
            }
        }
    }

    SystemPalette { id: palette }

    FindBar {
        id: findBar
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: navigationPanel.bottom
        anchors.topMargin: -10

        width: 180
        height: 45

        color: palette.window

        onFindNext: currentWebEngineView.findText(text)
        onFindPrev: currentWebEngineView.findText(text, WebEngineView.FindBackward)

        onStateChanged: {
            if (state == "hidden" && currentWebEngineView) {
                currentWebEngineView.findText("");
                currentWebEngineView.forceActiveFocus();
            }
        }
    }

    SequentialAnimation {
        id: navigationAnimation
        property int d: 600

        PropertyAnimation {
            target: currentWebEngineView
            property: "opacity"
            from: 1.0
            to: 0.1
            duration: navigationAnimation.d
        }

        PropertyAnimation {
            target: currentWebEngineView
            property: "opacity"
            from: 0.1
            to: 1.0
            duration: navigationAnimation.d
        }
    }

    Component.onCompleted: {
        utils.setLocale(appSettings.locale);
        viewListModel.create();
        viewListModel.select(viewListModel.count - 1);
    }
}
