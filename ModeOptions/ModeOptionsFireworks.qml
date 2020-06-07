import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
    onModeOptionsChanged: function () {
        if (typeof modeOptions == "undefined") {
            return;
        }

        sliderFadeRate.value = modeOptions.fadeRate
        sliderSparkRate.value = modeOptions.sparkRate
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Fireworks"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }

        Timer {
            id: fireworksOptionsChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                api.setModeOptions({
                    "fadeRate": sliderFadeRate.value,
                    "sparkRate": sliderSparkRate.value
                });
            }
        }

        RowLayout {
            Label {
                text: "Fade-Rate"
            }
            Slider {
                id: sliderFadeRate
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: fireworksOptionsChangeDelay.running = true
            }
        }

        RowLayout {
            Label {
                text: "Spark-Rate"
            }
            Slider {
                id: sliderSparkRate
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: fireworksOptionsChangeDelay.running = true
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
