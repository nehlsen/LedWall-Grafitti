import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
    onModeOptionsChanged: function () {
        if (typeof modeOptions == "undefined") {
            return;
        }

        sliderMultiBarsFadeRate.value = modeOptions.fadeRate
        sliderMultiBarsTravelSpeed.value = modeOptions.barTravelSpeed
        sliderMultiBarsNumberOfBars.value = modeOptions.numberOfBars
        sliderMultiBarsMaximumFrameDelay.value = modeOptions.maximumFrameDelay
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "MultiBars"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }

        Timer {
            id: multiBarsOptionsChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                api.setModeOptions({
                    "fadeRate": sliderMultiBarsFadeRate.value,
                    "barTravelSpeed": sliderMultiBarsTravelSpeed.value,
                    "numberOfBars": sliderMultiBarsNumberOfBars.value,
                    "maximumFrameDelay": sliderMultiBarsMaximumFrameDelay.value
                });
            }
        }

        RowLayout {
            Label {
                text: "Fade-Rate"
            }
            Slider {
                id: sliderMultiBarsFadeRate
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: multiBarsOptionsChangeDelay.running = true
            }
        }

        RowLayout {
            Label {
                text: "Travel-Speed"
            }
            Slider {
                id: sliderMultiBarsTravelSpeed
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: multiBarsOptionsChangeDelay.running = true
            }
        }

        RowLayout {
            Label {
                text: "Number of Bars"
            }
            Slider {
                id: sliderMultiBarsNumberOfBars
                from: 0
                to: 10
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: multiBarsOptionsChangeDelay.running = true
            }
        }

        RowLayout {
            Label {
                text: "Delay of new Bars"
            }
            Slider {
                id: sliderMultiBarsMaximumFrameDelay
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: multiBarsOptionsChangeDelay.running = true
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
