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
            }
        ]
    }

    BusyIndicator {
        id: loadingIndicator
        z: 100
        anchors.centerIn: parent
    }

    Action {
        id: optionsMenuAction
        text: "⋮"
        onTriggered: optionsMenu.open()
    }

    header: ToolBar {
        background: Rectangle { color: "white" }
//        Material.foreground: "white"

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
            onTriggered: Api.api.setMode(mainView.currentIndex);
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
                anchors.fill: parent
                horizontalAlignment: Label.AlignHCenter
            }

            // no options
        }

        Pane {
            id: settingsPageModeSample

            width: mainView.width
            height: mainView.height

            Label {
                text: "Sample"
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
                    Layout.fillWidth: true
                    horizontalAlignment: Label.AlignHCenter
                }

                Timer {
                    id: modeOptionsChangeDelay
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

                RowLayout {
                    Label {
                        text: "Speed"
                    }
                    Slider {
                        id: sliderAnimateSpeed
                        from: 0
                        to: 255
                        live: false
                        stepSize: 1
                        Layout.fillWidth: true

//                        onValueChanged: modeOptionsChangeDelay.running = true
                        onMoved: modeOptionsChangeDelay.running = true
                    }
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
//                    onCurrentIndexChanged: modeOptionsChangeDelay.running = true
                    onActivated: modeOptionsChangeDelay.running = true
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
