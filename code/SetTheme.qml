import QtQuick 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root

    anchors.centerIn: parent

    standardButtons: Dialog.Ok

    Column {
        spacing: 10
        Row {
            spacing: 5
            Label {
                text: "Light"
                width: 50
            }

            Rectangle {
                width: 50; height: 20
                color: 'white'
                border.width: 2
                border.color: 'black'
            }

            Rectangle {
                width: 50; height: 20
                color: colorGRAY
                border.width: 2
                border.color: 'black'
            }

            Rectangle {
                width: 50; height: 20
                color: 'white'
                border.width: 2
                border.color: 'black'
            }
        }

        Row {
            spacing: 5
            Label {
                text: "Dark"
                width: 50
            }

            Rectangle {
                width: 50; height: 20
                color: 'black'
                border.width: 2
                border.color: 'black'
            }

            Rectangle {
                width: 50; height: 20
                color: colorDARK
                border.width: 2
                border.color: 'black'
            }

            Rectangle {
                width: 50; height: 20
                color: 'cyan'
                border.width: 2
                border.color: 'black'
            }
        }
    }
}
