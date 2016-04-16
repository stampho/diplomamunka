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
    SliderBar.qml

HEADERS += \
    utils.h
