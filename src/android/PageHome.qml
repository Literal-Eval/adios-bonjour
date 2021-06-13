import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Page {
    id: root

    Button {
        id: buttStart

        width: 200; height: 100
        Material.background: Material.Blue
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 30
        }

        Text {
            id: buttStartText
            text: (serverRunning) ? "STOP": "START"
            color: 'white'
            font {
                family: "Calibri"
                pointSize: 20
            }
            anchors.centerIn: parent
        }

        onClicked: {
            if (serverRunning) {
                Server.stop()
                serverRunning = false
            }

            else {
                if (Server.start(texPort.text))
                {
                    serverRunning = true
                }
            }
        }
    }

    Label {
        id: labPor

        text: "por://"
        font {
            family: "Calibri"
            pointSize: 22
        }

        anchors{
            top: parent.top
            topMargin: 60
            left: parent.left
            leftMargin: 20
        }
    }

    Row {

        anchors{
            right: parent.right
            rightMargin: 20
            top: parent.top
            topMargin: 50
        }

        spacing: 10

        Rectangle {
            id: labIP

            width: 200; height: 50
            color: 'transparent'

            Label {
                id: serverAddrText
                text: (serverRunning) ? Server.getServerAddress(): "IDLE"
                anchors.centerIn: parent
                font {
                    family: "Calibri"
                    pointSize: 22
                }

            }
        }

        Rectangle {
            width: 20; height: 50
            color: 'transparent'

            Label {
                text: ":"
                anchors.centerIn: parent
                font {
                    family: "Calibri"
                    pointSize: 22
                }
            }
        }

        TextField {
            id: texPort

            width: 50; height: 50
            text: "2121"
            font {
                family: "Calibri"
                pointSize: 22
            }
            Material.background: Material.Red

            Component.onCompleted: {
                inputMask = '9999'
            }
        }
    }

    Label {
        id: connections

        text: "Connections"
        color: 'black'

        anchors {
            left: parent.left
            leftMargin: 20
            top: labPor.bottom
            topMargin: 20
        }

        font {
            family: "Calibri"
            pointSize: 20
        }
    }

    ListView {

    }
}


















