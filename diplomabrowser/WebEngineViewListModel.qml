import QtQuick 2.6

ListModel {
    id: root

    function newWebEngineView(parentItem) {
        if (!parentItem)
            parentItem = root;

        var webEngineView = Qt.createQmlObject("
                import QtWebEngine 1.3\n
                WebEngineView { property int index: -1 }\n
            ", parentItem);

        webEngineView.visible = false;
        webEngineView.index = root.count;

        root.append({ "webEngineView": webEngineView });
        return webEngineView;
    }
}
