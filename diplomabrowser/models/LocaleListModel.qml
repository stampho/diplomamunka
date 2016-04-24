import QtQuick 2.6

ListModel {
    id: root

    function addLocale(locale) {
        locale = locale.substring(0, 2);

        if (findLocale(locale) < 0)
            append({ "locale": locale, "name": Qt.locale(locale).nativeLanguageName });
    }

    function findLocale(locale) {
        for (var i = 0; i < count; ++i) {
            if (locale === get(i).locale)
                return i;
        }

        return -1;
    }

    Component.onCompleted: {
        addLocale(Qt.locale().name);
        addLocale("en");
        addLocale("de");
        addLocale("hu");
    }
}

