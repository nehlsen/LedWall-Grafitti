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
        sliderHue.first.value = modeOptions.colorHueLow
        sliderHue.second.value = modeOptions.colorHueHigh
        sliderSaturationLow.value = modeOptions.colorSaturationLow
        sliderSaturationHigh.value = modeOptions.colorSaturationHigh
        sliderValueLow.value = modeOptions.colorValueLow
        sliderValueHigh.value = modeOptions.colorValueHigh
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
                    "colorSaturationLow": sliderSaturationLow.value,
                    "colorSaturationHigh": sliderSaturationHigh.value,
                    "colorValueLow": sliderValueLow.value,
                    "colorValueHigh": sliderValueHigh.value
                });
            }
        }

        RowLayout {
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
        }

        RowLayout {
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
        }

        RowLayout {
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
        }

        RowLayout {
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
        }

        RowLayout {
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
        }

        ColumnLayout {
            Label {
                text: "Saturation"
                font.bold: true
            }
            RowLayout {
                Label {
                    text: "Low"
                }
                Slider {
                    id: sliderSaturationLow
                    from: 0
                    to: 255
                    live: false
                    stepSize: 1
                    Layout.fillWidth: true

                    onMoved: optionsChangeDelay.running = true
                }
            }
            RowLayout {
                Label {
                    text: "High"
                }
                Slider {
                    id: sliderSaturationHigh
                    from: 0
                    to: 255
                    live: false
                    stepSize: 1
                    Layout.fillWidth: true

                    onMoved: optionsChangeDelay.running = true
                }
            }
        }

        ColumnLayout {
            Label {
                text: "Value"
                font.bold: true
            }
            RowLayout {
                Label {
                    text: "Low"
                }
                Slider {
                    id: sliderValueLow
                    from: 0
                    to: 255
                    live: false
                    stepSize: 1
                    Layout.fillWidth: true

                    onMoved: optionsChangeDelay.running = true
                }
            }
            RowLayout {
                Label {
                    text: "High"
                }
                Slider {
                    id: sliderValueHigh
                    from: 0
                    to: 255
                    live: false
                    stepSize: 1
                    Layout.fillWidth: true

                    onMoved: optionsChangeDelay.running = true
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
