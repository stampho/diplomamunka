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
    HistoryListView.qml \
    TabListView.qml \
    WebEngineViewListModel.qml \
    WideEntry.qml \
    SliderBar.qml

HEADERS += \
    utils.h
