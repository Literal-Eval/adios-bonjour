import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Window 2.12

ListView {
    id: dirView

    width: parent.width - 20; height: parent.height - 160
    contentHeight: idModel.count * 25 + 50

    clip: true
    anchors.topMargin: 10
    anchors.leftMargin: 10
    anchors.left: parent.left

    boundsMovement: Flickable.StopAtBounds
    keyNavigationEnabled: true

    property var tempIndex
    property var selection: []
    property var f

    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier)
        {
            switch (event.key)
            {
            case Qt.Key_A:
                selectAll()
                break

            case Qt.Key_C:
                f.dislocate("copy")
                break

            case Qt.Key_X:
                f.dislocate("cut")
                break

            case Qt.Key_V:
                f.paste()
                console.log("paste")
                break
            }
        }
    }

    DragHandler {
        id: dragg
        target: null

        onActiveChanged: {
            if (active)
            {
                f.dislocate("copy")
            }
        }
    }

    Window {
        id: dragFiles

        title: "dragAmd"
        width: 72; height: 72
        flags: Qt.FramelessWindowHint
        color: "transparent"
        visible: dragg.active
        x: mapToGlobal(dragg.centroid.position.x,
                       dragg.centroid.position.y).x - 32
        y: mapToGlobal(dragg.centroid.position.x,
                       dragg.centroid.position.y).y - 32 - dirView.contentY

        Image {
            id: dragFilesImg
            source: "file:" + path + "/res/img/drag.png"
        }

        onVisibleChanged: {
            if (!visible)
            {
                var absPos = mapToGlobal(dragg.centroid.position.x,
                                         dragg.centroid.position.y - dirView.contentY)

                Backend.dragEnded(absPos.x, absPos.y)
            }
        }
    }

    model: ListModel {
        id: idModel
    }

    delegate: Rectangle {

        width: rootServer.width - 30
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

        ToolTip {
            id: tool

            delay: 1000
            contentItem: Text {
                font.pointSize: 10
                color: (backMode === "dark") ? "white": "black"
                text: name + /*"\n" + lastModified + */"\n" + size + " " + sizeType
            }

            background: Rectangle {
                color: backColor
                border.color: (backMode === "dark") ? "white": "black"
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                    tool.visible = true
                }

                else
                {
                    hoverInfo.visible = false
                    tool.visible = false
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
                    var lim = Math.abs((index - tempIndex))
                    var sign = (index - tempIndex) / lim

                    for (var sixnine = 0; sixnine <= lim; sixnine++)
                    {
                        selection[tempIndex + sixnine * sign] = true
                        idModel.get(tempIndex + sixnine * sign)["selected"] = true
                    }

                    break

                default:
                    selection = []
                    selection[index] = true

                    for (var i = 0; i < idModel.count; i++)
                    {
                        idModel.get(i)["selected"] = false
                    }

                    idModel.get(index)["selected"] = true
                    tempIndex = index
                    break
                }

                dirView.focus = true
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

            width: 20; height: 20
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/folder.png"

            visible: (type === "folder")
        }

        Image {
            id: iconFileIndicator

            width: 20; height: 20
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/" + ext + ".png"

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

    Connections {
        target: Backend

        function onDragEnded(x, y)
        {
            if ((x > rootServer.x && x < (rootServer.x + rootServer.width)) &&
                    (y > rootServer.y && y < (rootServer.y + rootServer.height)))
            {
                f.paste()
            }
        }
    }

    function selectAll()
    {
        for (var index = 0; index < idModel.count; index++)
        {
            idModel.get(index)["selected"] = true
            selection[index] = true
        }
    }
}









