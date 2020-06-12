import QtQuick 2.0
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
        sliderHueLow.value = modeOptions.colorHueLow
        sliderHueHigh.value = modeOptions.colorHueHigh
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
                    "colorHueLow": sliderHueLow.value,
                    "colorHueHigh": sliderHueHigh.value,
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

        ColumnLayout {
            Label {
                text: "Hue"
                font.bold: true
            }
            RowLayout {
                Label {
                    text: "Low"
                }
                Slider {
                    id: sliderHueLow
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
                    id: sliderHueHigh
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
