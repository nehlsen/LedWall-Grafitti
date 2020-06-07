import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
//    id: settingsPageModeBars

//    width: parent.width
//    height: parent.height

//    function onOptionsChanged(modeObject)
//    {
//        console.log("ModeOptionsBars::onOptionsChanged");
//    }

    onModeOptionsChanged: function () {
        if (typeof modeOptions == "undefined") {
            return;
        }

        console.log("bars options changed");
        console.log(JSON.stringify(modeOptions));
        sliderBarsFadeRate.value = modeOptions.fadeRate
        sliderBarsBarsRate.value = modeOptions.barsRate
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Bars"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }

        Timer {
            id: barsOptionsChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                api.setModeOptions({
                    "fadeRate": sliderBarsFadeRate.value,
                    "barsRate": sliderBarsBarsRate.value
                });
            }
        }

        RowLayout {
            Label {
                text: "Fade-Rate"
            }
            Slider {
                id: sliderBarsFadeRate
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: barsOptionsChangeDelay.running = true
            }
        }

        RowLayout {
            Label {
                text: "Bars-Rate"
            }
            Slider {
                id: sliderBarsBarsRate
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: barsOptionsChangeDelay.running = true
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
