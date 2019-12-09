import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    id: rect
    width: 350
    height: 400

    property alias toggler: toggler

    Switch {
        id: toggler
        text: "Power"
    }
}
