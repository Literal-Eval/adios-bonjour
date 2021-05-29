import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: titleBar

    property var titleText: ""
    property variant newPos: "1, 1"
    property var targetWin;

    width: parent.width; height: 30
    color: backColor

    Label {
        id: title

        text: titleText
        color: frontColor
        anchors.centerIn: parent
    }

    Image {
        id: iconMinimize

        width: 16; height: 16
        anchors.right: iconClose.left
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
            var delta = Qt.point(mouse.x - newPos.x, mouse.y - newPos.y)
            targetWin.x += delta.x
            targetWin.y += delta.y
        }
    }
}







