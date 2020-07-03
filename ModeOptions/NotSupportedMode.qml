import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
    Label {
        text: "Not Supported"
        font.pixelSize: 18
        font.bold: true
        anchors.fill: parent
        horizontalAlignment: Label.AlignHCenter
    }

    Label {
        text: "The selected Mode \"" + modeName + "\" is not directly supported by your Version of Grafitti. You can activate the Mode but not change or view its Settings."
    }

    // no options
}
