import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: currentDir

    width: 380; height: 380
    contentHeight: idModel.count * 25 + 50

    clip: true
    anchors.topMargin: 10
    anchors.leftMargin: 10
    anchors.left: parent.left

    boundsMovement: Flickable.StopAtBounds

    model: ListModel {
        id: idModel
    }

    delegate: Rectangle {

        width: 350
        color: colorDARK
        height: 25

        Rectangle {

            width: parent.width + 4
            radius: 5
            x: parent.x
            color: Qt.rgba(1, 1, 1, 0.1)
            height: 25

            visible: parent.focus
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                parent.focus = true
            }

            onDoubleClicked: {
                if (type === "folder")
                {
                    bServer.setCurDir(name)
                    fillModel()
                    var cAddress = bServer.curDir()
                    addressBar.currentAddress = cAddress
                }
            }
        }

        Image {
            id: iconFolderIndicator

            width: 16; height: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/folder.ico"

            visible: (type === "folder")
        }

        Image {
            id: iconFileIndicator

            width: 16; height: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/file.ico"

            visible: (type === "file")
        }

        Text {
            id: fileName

            text: name
            width: 200
            clip: true
            font.pointSize: 10
            font.family: 'Calibri'
            color: 'white'

            anchors.left: iconFileIndicator.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
        }

        Text {
            id: fileSize

            text: (type == "file") ? (size + " " + sizeType): "NA"
            font.pointSize: 10
            font.family: "Calibri"
            color: 'white'

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
        }
    }

    ScrollBar.vertical: ScrollBar { }
}



