TEMPLATE = app

QT += qml quick widgets webengine

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    controls/Button.qml \
    controls/BrowserButton.qml \
    controls/FlatButton.qml \
    AddressBar.qml \
    BrowserSwitch.qml \
    CompactEntry.qml \
    FindBar.qml \
    HistoryListView.qml \
    LocaleListModel.qml \
    TabListView.qml \
    WebEngineViewListModel.qml \
    WideEntry.qml \
    SettingsPanel.qml \
    SliderBar.qml

HEADERS += \
    utils.h
