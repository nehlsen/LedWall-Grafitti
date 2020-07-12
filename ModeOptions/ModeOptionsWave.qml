import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
    onModeOptionsChanged: function () {
        if (typeof modeOptions == "undefined") {
            return;
        }

        comboWaveMode.currentIndex = modeOptions.waveMode
        comboWaveDirection.currentIndex = modeOptions.waveDirection
        sliderWaveLength.value = modeOptions.waveLength
        sliderSpeed.value = modeOptions.speed
        sliderHue.second.value = modeOptions.colorHueHigh
        sliderHue.first.value = modeOptions.colorHueLow
        sliderSaturation.second.value = modeOptions.colorSaturationHigh
        sliderSaturation.first.value = modeOptions.colorSaturationLow
        sliderValue.second.value = modeOptions.colorValueHigh
        sliderValue.first.value = modeOptions.colorValueLow
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Wave"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }

        Timer {
            id: optionsChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                api.setModeOptions({
                    "waveMode": comboWaveMode.currentIndex,
                    "waveDirection": comboWaveDirection.currentIndex,
                    "waveLength": sliderWaveLength.value,
                    "speed": sliderSpeed.value,
                    "colorHueLow": sliderHue.first.value,
                    "colorHueHigh": sliderHue.second.value,
                    "colorSaturationLow": sliderSaturation.first.value,
                    "colorSaturationHigh": sliderSaturation.second.value,
                    "colorValueLow": sliderValue.first.value,
                    "colorValueHigh": sliderValue.second.value
                });
            }
        }

        GridLayout {
            columns: 2

            Label {
                text: "Wave Mode"
            }
            ComboBox {
                id: comboWaveMode
                Layout.fillWidth: true
                model: [
                    "Horizontal",
                    "Vertical",
                    "RadialCircle",
                    "RadialRect"
                ]

                onActivated: optionsChangeDelay.running = true
            }

            Label {
                text: "Direction"
            }
            ComboBox {
                id: comboWaveDirection
                Layout.fillWidth: true
                model: [
                    "Forward",
                    "Reverse"
                ]

                onActivated: optionsChangeDelay.running = true
            }

            Label {
                text: "Wave Length"
            }
            Slider {
                id: sliderWaveLength
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: optionsChangeDelay.running = true
            }

            Label {
                text: "Speed"
            }
            Slider {
                id: sliderSpeed
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                onMoved: optionsChangeDelay.running = true
            }

            Label {
                text: "Hue"
                font.bold: true
            }
            Rectangle {
                Layout.fillWidth: true
                height: sliderHue.height
                radius: 8
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: Qt.hsva(0.0, 1, 1, 1) }
                    GradientStop { position: 0.1; color: Qt.hsva(0.1, 1, 1, 1) }
                    GradientStop { position: 0.2; color: Qt.hsva(0.2, 1, 1, 1) }
                    GradientStop { position: 0.3; color: Qt.hsva(0.3, 1, 1, 1) }
                    GradientStop { position: 0.4; color: Qt.hsva(0.4, 1, 1, 1) }
                    GradientStop { position: 0.5; color: Qt.hsva(0.5, 1, 1, 1) }
                    GradientStop { position: 0.6; color: Qt.hsva(0.6, 1, 1, 1) }
                    GradientStop { position: 0.7; color: Qt.hsva(0.7, 1, 1, 1) }
                    GradientStop { position: 0.8; color: Qt.hsva(0.8, 1, 1, 1) }
                    GradientStop { position: 0.9; color: Qt.hsva(0.9, 1, 1, 1) }
                }

                RangeSlider {
                    id: sliderHue
                    from: 0
                    to: 255
                    live: false
                    stepSize: 1
                    width: parent.width

                    first.onMoved: optionsChangeDelay.running = true
                    second.onMoved: optionsChangeDelay.running = true
                }
            }

            Label {
                text: "Saturation"
                font.bold: true
            }
            RangeSlider {
                id: sliderSaturation
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                first.onMoved: optionsChangeDelay.running = true
                second.onMoved: optionsChangeDelay.running = true
            }

            Label {
                text: "Value"
                font.bold: true
            }
            RangeSlider {
                id: sliderValue
                from: 0
                to: 255
                live: false
                stepSize: 1
                Layout.fillWidth: true

                first.onMoved: optionsChangeDelay.running = true
                second.onMoved: optionsChangeDelay.running = true
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
