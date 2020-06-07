import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ModeOptionsPane {
    onModeOptionsChanged: function () {
        if (typeof modeOptions == "undefined") {
            return;
        }

        sliderAnimateSpeed.value = modeOptions.animateSpeed
        comboAnimation.currentIndex = modeOptions.animation
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Hsiboy"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }

        Timer {
            id: hsiboyOptionsChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                api.setModeOptions({
                    "animateSpeed": sliderAnimateSpeed.value,
                    "animation": comboAnimation.currentIndex
                });
            }
        }

//                RowLayout {
//                    Label {
//                        text: "Speed"
//                    }
//                    Slider {
//                        id: sliderAnimateSpeed
//                        from: 0
//                        to: 255
//                        live: false
//                        stepSize: 1
//                        Layout.fillWidth: true

////                        onValueChanged: hsiboyOptionsChangeDelay.running = true
//                        onMoved: hsiboyOptionsChangeDelay.running = true
//                    }
//                }

        Label {
            text: "Mode"
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }
        ComboBox {
            id: comboAnimation
            Layout.fillWidth: true
            model: [
                "RingPair",
                "DoubleChaser",
                "TrippleBounce",
                "WaveInt",
                "Wave",
                "BlueSpark - slow",
                "BlueSpark - fast",
                "WhiteSpark - slow",
                "WhiteSpark - fast",
                "RainbowSpark"
            ]

            onActivated: hsiboyOptionsChangeDelay.restart()
        }


        Label {
            text: "Speed"
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Label.AlignHCenter
        }
        Dial {
            id: sliderAnimateSpeed
            from: 0
            to: 255
            stepSize: 1
            Layout.fillWidth: true

            onMoved: hsiboyOptionsChangeDelay.restart()

            Label {
                text: Math.round(parent.value)
                anchors.centerIn: parent
            }
        }

        Rectangle {
            Layout.preferredHeight: 500
        }
    }
}
