import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: typeDenoter

    width: currentDir.width - 35
    color: colorDARK
    height: 30

    anchors.topMargin: 10

    Label {
        text: "Name"
        color: 'white'

        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Calibri"
            pointSize: 10
        }
    }

    Label {
        text: "Last Modified"
        color: 'white'
        anchors.centerIn: parent

        font {
            family: "Calibri"
            pointSize: 10
        }
    }

    Label {
        text: "Size"
        color: "white"

        anchors {
            right: parent.right
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Calibri"
            pointSize: 10
        }
    }
}



