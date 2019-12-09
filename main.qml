import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import "api.js" as Api

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Component.onCompleted: {
         Api.api.update();
    }

    BusyIndicator {
        id: loadingIndicator
        z: 100
        anchors.centerIn: parent
    }

    ColumnLayout {
        id: mainLayout

        PowerForm {
            id: power
//            toggler.onToggled: Api.api.setPower(toggler.isChecked)
            toggler.onToggled: Api.api.togglePower()
        }

        Mode {
            id: mode
//            anchors.top: parent.top
//            anchors.topMargin: 10
//            anchors.right: parent.right
//            anchors.rightMargin: 10
//            anchors.left: parent.left
//            anchors.leftMargin: 10
        }

        state: "loading"
        states: [
            State {
                name: "offline"
                PropertyChanges {
                    target: mainLayout
                    enabled: false
                }
            },
            State {
                name: "loading"
                PropertyChanges {
                    target: mainLayout
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
                    target: mainLayout
                    enabled: true
                }
                PropertyChanges {
                    target: loadingIndicator
                    visible: false
                }
            }
        ]
    }

    Rectangle {
        id: button
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: buttonText.width + 10
        height: buttonText.height + 10
        radius : 5;
        border.width: 2;
        antialiasing: true

        Text {
            id: buttonText;
            text: "do it!"
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: Api.getMode()
        }
    }
}
