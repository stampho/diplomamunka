import QtQuick 2.6

ListModel {
    id: root

    function newWebEngineView(parentItem) {
        if (!parentItem)
            parentItem = root

        var webEngineView = Qt.createQmlObject("
                import QtQuick 2.6\n
                import QtWebEngine 1.3\n
                WebEngineView {\n
                    anchors.fill: parent\n
                    visible: false\n
                }\n
            ", parentItem)

        root.append({ "webEngineView": webEngineView })
        return webEngineView
    }
}
