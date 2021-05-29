import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: dirView

    width: 380; height: 370
    contentHeight: idModel.count * 25 + 50

    clip: true
    anchors.topMargin: 10
    anchors.leftMargin: 10
    anchors.left: parent.left

    boundsMovement: Flickable.StopAtBounds
    keyNavigationEnabled: true

    property var selection: []

    model: ListModel {
        id: idModel
    }

    delegate: Rectangle {

        width: 350
        color: backColor
        height: 25

        Rectangle {
            id: selectedInfo

            width: parent.width + 4
            radius: 5
            x: parent.x
            color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.15): Qt.rgba(0, 0, 0, 0.15)
            height: 25

            visible: selected
        }

        Rectangle {
            id: hoverInfo

            width: parent.width + 4
            radius: 5
            x: parent.x
            color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.1): Qt.rgba(0, 0, 0, 0.1)
            height: 25

            visible: false
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                }

                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {
                switch (mouse.modifiers)
                {

                case Qt.ControlModifier:
                    selection[index] = !(selection[index])
                    idModel.get(index)["selected"] = !(idModel.get(index)["selected"])
                    break

                case Qt.ShiftModifier:
                    break

                default:
                    selection = []
                    selection[index] = true

                    for (var i = 0; i < idModel.count; i++)
                    {
                        idModel.get(i)["selected"] = false
                    }

                    idModel.get(index)["selected"] = true
                    break
                }
            }

            onDoubleClicked: {
                if (type === "folder")
                {
                    bServer.setCurDir(name)
                    fillModel()
                    var cAddress = bServer.curDir()
                    addressBar.currentAddress = cAddress
                }

                else
                {
                    bServer.setClipDir()
                    bServer.fillQueu([name], "open", "")
                    progress.visible = true
                }
            }
        }

        Image {
            id: iconFolderIndicator

            width: 16; height: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:" + path + "/res/img/folder.ico"

            visible: (type === "folder")
        }

        Image {
            id: iconFileIndicator

            width: 16; height: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:" + path + "/res/img/file.ico"

            visible: (type === "file")
        }

        Text {
            id: fileName

            text: name
            width: 200
            clip: true
            font.pointSize: 10
            font.family: 'Calibri'
            color: frontColor

            anchors.left: iconFileIndicator.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
        }

        Text {
            id: fileSize

            text: (type == "file") ? (size + " " + sizeType): "NA"
            font.pointSize: 10
            font.family: "Calibri"
            color: frontColor

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
        }
    }

    ScrollBar.vertical: ScrollBar { }
}



