import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Page {
    id: pageAbout

    Button {
        id: root

        width: 100; height: 50
        Material.background: Material.Red
        anchors {
            right: parent.right
            rightMargin: 20
        }

        Text {
            id: buttStartText
            text: (serverRunning) ? "STOP": "START"
            anchors.centerIn: parent
        }

        onClicked: {
            if (serverRunning) {
                Server.stop(); serverRunning = false
            }

            else {
                if (Server.start()) serverRunning = true
            }
        }
    }
}
