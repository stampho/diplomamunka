TEMPLATE = app

QT += qml quick widgets webengine

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    AddressBar.qml \
    FindBar.qml \
    controls/BrowserButton.qml \
    controls/BrowserSwitch.qml \
    controls/Button.qml \
    controls/CompactEntry.qml \
    controls/FlatButton.qml \
    controls/WideEntry.qml \
    models/LocaleListModel.qml \
    models/WebEngineViewListModel.qml \
    views/HistoryListView.qml \
    views/TabListView.qml \
    views/SettingsPanel.qml \
    views/SliderPanel.qml

HEADERS += \
    utils.h
