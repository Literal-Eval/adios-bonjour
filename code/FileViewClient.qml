import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: currentDir

    width: 700; height: 370
    contentHeight: idModel.count * 25 + 50

    clip: true
    anchors.topMargin: 10
    anchors.leftMargin: 150
    anchors.left: parent.left
    focus: true

    boundsMovement: Flickable.StopAtBounds
    keyNavigationEnabled: true

    property variant selection: []

    model: ListModel {
        id: idModel
    }

    delegate: Rectangle {

        width: 680
        color: backColor
        height: 25

        Rectangle {
            id: selectionNotify

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
            id: mouse
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                    ToolTip.delay = 1000
                    ToolTip.show(name + "\n" + lastModified + "\n" + size + " " + sizeType, -1)                    
                }

                else
                {
                    hoverInfo.visible = false
                    ToolTip.hide()
                }
            }

            onClicked: {

                switch (mouse.modifiers)
                {

                case Qt.ControlModifier:
                    idModel.get(index)["selected"] = !(idModel.get(index)["selected"])
                    selection[index] = idModel.get(index)["selected"]
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

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconFileIndicator.right
            anchors.leftMargin: 20
        }

        Text {
            id: fileLastModified

            text: lastModified
            font.pointSize: 10
            font.family: 'Calibri'
            color: frontColor

            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
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

