import QtQuick 2.0
import QtQuick.Controls 2.12

ModeOptionsPane {
//    id: settingsPageModeStatus
//    id: Status

//    width: parent.width
//    height: parent.height

//    function onOptionsChanged(modeObject)
//    {
//        console.log("ModeOptionsStatus::onOptionsChanged");
//    }

//    modeName: "Status"

//    onModeOptionsChanged: function () {
//        console.log("status options changed");
//        console.log(JSON.stringify(modeOptions));
//    }

    Label {
        text: "Status"
        font.pixelSize: 18
        font.bold: true
        anchors.fill: parent
        horizontalAlignment: Label.AlignHCenter
    }

    // no options
}
