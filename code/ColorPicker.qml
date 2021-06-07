import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root
    width: 300; height: 460
    title: "Set Color..."

    property var mode

    closePolicy: Popup.CloseOnEscape

    anchors.centerIn: parent
    standardButtons: Dialog.Ok

    onAccepted: {
        var col = (slidRed.value + " " +
                   slidGreen.value + " " +
                   slidBlue.value + " " +
                   slidAlpha.value)

        console.log(col)

        Backend.setTheme(slidRed.value + " " +
                         slidGreen.value + " " +
                         slidBlue.value + " " +
                         (255 - slidAlpha.value), mode)
    }

    Column {
        spacing: 2
        anchors.fill: parent

        Rectangle {
            width: 250; height: 250
            color: Qt.rgba(slidRed.value / 255,
                           slidGreen.value / 255,
                           slidBlue.value / 255,
                           slidAlpha.value / 255)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Slider {
            id: slidRed
            from: 0; to: 255
            width: 280
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Material.accent: Material.Red
        }

        Slider {
            id: slidGreen
            from: 0; to: 255
            width: 280
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Material.accent: Material.Green
        }

        Slider {
            id: slidBlue
            from: 0; to: 255
            width: 280
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Material.accent: Material.Blue
        }

        Slider {
            id: slidAlpha
            from: 0; to: 255
            value: 255
            width: 280
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Material.accent: Material.Grey
        }
    }
}
