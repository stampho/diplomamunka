import QtQuick 2.6
import QtQuick.Controls 1.4
import QtWebEngine 1.3

ListModel {
    id: root

    property WebEngineView currentWebEngineView: null
    property StackView wrapper;
    signal selected(int index)
    signal created(WebEngineView webEngineView)

    function create(index, url) {
        if (index == undefined)
            index = root.count;

        var webEngineView = Qt.createQmlObject("
                import QtWebEngine 1.3\n
                WebEngineView { property int index: -1 }\n
            ", wrapper);

        webEngineView.visible = false;
        webEngineView.index = index;

        if (url != undefined)
            webEngineView.url = url;

        if (index == root.count) {
            root.append({ "webEngineView": webEngineView });
        } else {
            root.insert(index, { "webEngineView": webEngineView});
            for (var i = index + 1; i < count; ++i)
                get(i).webEngineView.index = i;
        }

        created(webEngineView);
    }

    function select(index) {
        if (index < 0) {
            currentWebEngineView = null;
            wrapper.clear();
        } else {
            currentWebEngineView = get(index).webEngineView;
            wrapper.push({ item: currentWebEngineView, replace: true });
        }

        selected(index);
    }

    function close(index) {
        if (count == 0)
            return;

        var currentIndex = wrapper.currentItem.index;
        var webEngineView = get(currentIndex).webEngineView;

        remove(index);

        if (!count) {
            select(-1);
            webEngineView.destroy();
            return;
        }

        for (var i = index; i < count; ++i)
            get(i).webEngineView.index = i;

        if ((currentIndex == index && currentIndex == count) || currentIndex > index)
            --currentIndex;

        select(currentIndex);
        //webEngineView.destroy(1000);
    }

    function restart(index) {
        var currentIndex = wrapper.currentItem.index;
        var webEngineView = get(index).webEngineView;
        var url = webEngineView.url;

        close(index);
        create(index, url);

        if (index == currentIndex)
            select(index);

        webEngineView.destroy(1000);
    }
}
