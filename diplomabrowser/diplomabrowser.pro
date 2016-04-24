TEMPLATE = app

QT += qml quick widgets webengine

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

OTHER_FILES += \
    main.qml \
    AddressBar.qml \
    BrowserButton.qml \
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
