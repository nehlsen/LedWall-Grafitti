import QtQuick 2.0

Rectangle {
    id: rect
    width: 350
    height: 400

    property alias name: txtMode

    Text {
        id: lblMode
        text: "Mode:"
        anchors.margins: 10
    }

    Text {
        id: txtMode
        text: "loading..."
        anchors.left: lblMode.right
        anchors.margins: 10
    }
}
