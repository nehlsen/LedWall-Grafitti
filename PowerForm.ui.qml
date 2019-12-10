import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    id: rect

    property alias toggler: toggler

    Switch {
        id: toggler
        text: "Power"
        anchors.fill: parent
    }
}
