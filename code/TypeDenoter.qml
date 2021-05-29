import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: typeDenoter

    width: dirView.width - 35
    color: backColor
    height: 30

    anchors.topMargin: 10

    Label {
        text: "Name"
        color: frontColor

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
        color: frontColor
        anchors.centerIn: parent

        font {
            family: "Calibri"
            pointSize: 10
        }
    }

    Label {
        text: "Size"
        color: frontColor

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



