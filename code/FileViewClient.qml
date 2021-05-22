import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: currentDir

    width: 700; height: 380
    contentHeight: idModel.count * 25 + 50

    clip: true
    anchors.topMargin: 10
    anchors.leftMargin: 150
    anchors.left: parent.left

    boundsMovement: Flickable.StopAtBounds

    model: ListModel {
        id: idModel
    }

    delegate: Rectangle {

        width: 680
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
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    ToolTip.delay = 1000
                    ToolTip.show(name + "\n" + lastModified + "\n" + size + " " + sizeType, -1)
                }
            }

            onClicked: {
                parent.focus = true
            }

            onDoubleClicked: {
                if (type === "folder")
                {
                    bClient.setCurDir(name)
                    fillModel()
                    var cAddress = bClient.curDir()
                    addressBar.currentAddress = cAddress
                }

                else
                {
                    bClient.openFile(name)
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

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconFileIndicator.right
            anchors.leftMargin: 20
        }

        Text {
            id: fileLastModified

            text: lastModified
            font.pointSize: 10
            font.family: 'Calibri'
            color: 'white'

            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
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

