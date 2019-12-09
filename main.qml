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
    title: qsTr("Grafitti")

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
}
