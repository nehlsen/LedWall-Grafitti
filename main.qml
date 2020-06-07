import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

import "api.js" as Api

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Grafitti")

    Component.onCompleted: {
        Api.api.setHost(settings.host);
        Api.api.update();
    }

    Settings {
        id: settings
        property string host: "ledwall.local"
    }

    Item {
        id: control
        state: "loading"
        states: [
            State {
                name: "loading"
                PropertyChanges {
                    target: powerSwitch
                    enabled: false
                }
                PropertyChanges {
                    target: mainView
                    enabled: false
                }
                PropertyChanges {
                    target: loadingIndicator
                    visible: true
                }
                PropertyChanges {
                    target: generalError
                    visible: false
                }
            },
            State {
                name: "ready"
                PropertyChanges {
                    target: powerSwitch
                    enabled: true
                }
                PropertyChanges {
                    target: mainView
                    enabled: true
                }
                PropertyChanges {
                    target: loadingIndicator
                    visible: false
                }
                PropertyChanges {
                    target: generalError
                    visible: false
                }
            },
            State {
                name: "error"
                PropertyChanges {
                    target: powerSwitch
                    enabled: false
                }
                PropertyChanges {
                    target: mainView
                    enabled: false
                }
                PropertyChanges {
                    target: loadingIndicator
                    visible: false
                }
                PropertyChanges {
                    target: generalError
                    visible: true
                }
            }
        ]
    }

    BusyIndicator {
        id: loadingIndicator
        z: 100
        anchors.centerIn: parent
    }
    Label {
        id: generalError
        z: 110
        anchors.centerIn: parent
        text: "<b>Connection failed!</b>"
        color: "red"
    }

    Action {
        id: optionsMenuAction
        text: "⋮"
        onTriggered: optionsMenu.open()
    }

    header: ToolBar {
        background: Rectangle { color: "white" }

        RowLayout {
            spacing: 20
            anchors.fill: parent

            Switch {
                id: powerSwitch
                onToggled: Api.api.togglePower()
                text: "Power"
            }

            Label {
                id: titleLabel
                text: "Grafitti"
                font.pixelSize: 20
                elide: Label.ElideRight
//                leftPadding: optionsMenuButton.width
//                rightPadding: powerSwitch.width
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                id: optionsMenuButton
                action: optionsMenuAction

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: "Settings"
                        onTriggered: settingsDialog.open()
                    }
                    Action {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    SwipeView {
        id: mainView

        currentIndex: 2
        anchors.fill: parent

        Timer {
            id: modeChangeDelay
            interval: 750
            running: false
            repeat: false
            onTriggered: {
                Api.api.setMode(mainView.currentIndex);
                lblActivated.opacity = 1.0
                lblActivatedHide.start();
            }
        }

        // fixme: handle only user change of index (not programatically)
        onCurrentIndexChanged: {
            console.log("swiped! " + currentIndex)
            modeChangeDelay.running = true
        }

        Pane {
            id: settingsPageModeStatus

            width: mainView.width
            height: mainView.height

            Label {
                text: "Status"
                font.pixelSize: 18
                font.bold: true
                anchors.fill: parent
                horizontalAlignment: Label.AlignHCenter
            }

            // no options
        }

        Pane {
            id: settingsPageModeBars

            width: mainView.width
            height: mainView.height

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
                        Api.api.setModeOptions({
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

        Pane {
            id: settingsPageModeMultiBars

            width: mainView.width
            height: mainView.height

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
                        Api.api.setModeOptions({
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

        Pane {
            id: settingsPageModeFireworks

            width: mainView.width
            height: mainView.height

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
                        Api.api.setModeOptions({
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

        Pane {
            id: settingsPageModeSample

            width: mainView.width
            height: mainView.height

            Label {
                text: "Sample"
                font.pixelSize: 18
                font.bold: true
                anchors.fill: parent
                horizontalAlignment: Label.AlignHCenter
            }

            // no options
        }

        Pane {
            id: settingsPageModeHsiboy

            width: mainView.width
            height: mainView.height

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
                        Api.api.setModeOptions({
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
    }

    PageIndicator {
        id: indicator

        count: mainView.count
        currentIndex: mainView.currentIndex

        anchors.bottom: mainView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: lblActivated
        text: "Activated!"
        font.pixelSize: 20
        font.bold: true
        anchors.centerIn: parent
        opacity: 0

        ParallelAnimation {
            id: lblActivatedHide
            ScaleAnimator {
                target: lblActivated
                from: 1.0
                to: 1.8
                duration: 600
                easing: Easing.OutQuad
            }
            OpacityAnimator {
                target: lblActivated
                from: 1.0
                to: 0.0
                duration: 600
                easing: Easing.OutQuad
            }
        }
    }

    Dialog {
        id: settingsDialog
        x: Math.round((window.width - width) / 2)
        y: Math.round(window.height / 6)
        width: Math.round(Math.min(window.width, window.height) / 3 * 2)
        modal: true
        focus: true
        title: "Settings"

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            settings.host = editHost.text
            Api.api.setHost(settings.host);
            settingsDialog.close()
        }
        onRejected: {
            editHost.text = settings.host
            settingsDialog.close()
        }

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            RowLayout {
                spacing: 10

                Label {
                    text: "LedWall Host:"
                }

                TextEdit {
                    id: editHost
                    focus: true
                    Layout.fillWidth: true
                    Component.onCompleted: {
                        text = settings.host
                    }
                }
            }

            Label {
                text: "Restart required"
                color: "#e41e25"
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        title: "About"
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                width: aboutDialog.availableWidth
                text: "Grafitti"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Most awesome Tool to control an original LedWall."
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }
}
