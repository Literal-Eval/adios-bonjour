import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Window 2.12

Rectangle {
    id: titleBar

    property var titleText: ""
    property var newPos: "1, 1"
    property var targetWin
    property var viewMode: "normal"

    width: parent.width; height: 30
    color: backColor

    ToolTip {
        id: tool

        delay: 1000
        contentItem: Text {
            font.pointSize: 10
            color: (backMode === "dark") ? "white": "black"
            text: tool.text
        }

        background: Rectangle {
            color: backColor
            border.color: (backMode === "dark") ? "white": "black"
        }
    }

    Image {
        id: title

        width: 16; height: 16
        anchors.centerIn: parent
        source: "file:" + path + "/res/img/" +
                ((backMode === "light") ? "light": "dark") + "/" + titleText + ".png"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onHoveredChanged: {
                if (containsMouse)
                {
                    tool.text = titleText
                    tool.x = titleBar.width / 2 - 35
                    tool.visible = true
                }

                else
                {
                    tool.visible = false
                }
            }
        }
    }

    Image {
        id: iconMinimize

        width: 16; height: 16
        anchors.right: iconMaximize.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: "file:" + path + "/res/img/minus.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.color = Qt.rgba(0.784, 0.784, 0.784, 0.3)
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {
                showMinimized()
            }
        }
    }

    Image {
        id: iconMaximize

        width: 16; height: 16
        anchors.right: iconClose.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: "file:" + path + "/res/img/maximize.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.color = Qt.rgba(0.784, 0.784, 0.784, 0.3)
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {
                Backend.resize()
            }
        }
    }

    Image {
        id: iconClose

        width: 16; height: 16
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "file:" + path + "/res/img/close.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.color = Qt.rgba(1, 0, 0, 0.3)
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {
                bServer.endCurl()
                Qt.quit()
            }
        }
    }

    Rectangle {
        id: hoverInfo

        width: 24; height: 24
        radius: 5
        color: Qt.rgba(0.784, 0.784, 0.784, 0.3)
        visible: false
    }

    MouseArea {
        id: mouse
        width: parent.width - 60
        height: parent.height

        onPressed: {
            newPos = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            if (viewMode === "normal")
            {
                var delta = Qt.point(mouse.x - newPos.x, mouse.y - newPos.y)
                targetWin.x += delta.x
                targetWin.y += delta.y

                Backend.setWindowPos(targetWin.x, targetWin.y,
                                     targetWin.width, targetWin.height,
                                     targetWin.title)
            }
        }
    }

    Connections {
        target: Backend

        function onResize()
        {
            if (targetWin === rootClient)
            {
                if (viewMode === "normal")
                {
                    targetWin.height = Screen.height
                    targetWin.width = (Screen.width * 66 ) / 100
                    targetWin.y = 0
                    targetWin.x = 0
                    viewMode = "maximized"
                }

                else
                {
                    targetWin.height = 530
                    targetWin.width = 870
                    targetWin.y = (Screen.height - 530) / 2
                    targetWin.x = (Screen.width - 870) / 2
                    viewMode = "normal"
                }
            }

            else
            {
                if (viewMode === "normal")
                {
                    targetWin.height = Screen.height
                    targetWin.width = (Screen.width * 34) / 100
                    targetWin.y = 0
                    targetWin.x = (Screen.width * 66) / 100
                    viewMode = "maximized"
                }

                else
                {
                    targetWin.height = 530
                    targetWin.width = 400
                    targetWin.y = (Screen.height - 530) / 2
                    targetWin.x = (Screen.width - 870 ) / 2
                    viewMode = "normal"
                }
            }
        }
    }
}







