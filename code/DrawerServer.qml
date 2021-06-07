import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Drawer {
    id: drawer

    width: 60; height: parent.height
    background: Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0;
                color: (backMode === "light") ? Qt.rgba(1, 1, 1, 0.8): Qt.rgba(0.157, 0.157, 0.157, 0.8) }
            GradientStop { position: 0.5;
                color: (backMode === "light") ? Qt.rgba(1, 1, 1, 1): Qt.rgba(0.157, 0.157, 0.157, 1) }
            GradientStop { position: 1.0;
                color: (backMode === "light") ? Qt.rgba(1, 1, 1, 0.8): Qt.rgba(0.157, 0.157, 0.157, 0.8) }
        }
    }

    ToolTip {
        id: tool

        delay: 1000
        contentItem: Text {
            font.pointSize: 11
            color: (backMode === "dark") ? "white": "black"
            text: tool.text
        }

        background: Rectangle {
            color: backColor
            border.color: (backMode === "dark") ? "white": "black"
        }
    }

    Column {
        width: contentWidth; height: contentHeight
        spacing: 20
        anchors.centerIn: parent

        Image {
            id: buttGetIp
            width: 48; height: 48

            source: "file:" + path + "/res/img/refresh.png"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onHoveredChanged: {
                    if (containsMouse)
                    {
                        tool.text = "Re Enter IP"
                        tool.x = parent.x + 60
                        tool.y = parent.y + 242
                        tool.visible = true
                    }

                    else
                    {
                        tool.visible = false
                    }
                }

                onClicked: {
                    dialogGetIp.visible = true
                }
            }
        }

//        Image {
//            id: buttSetTheme
//            width: 48; height: 48

//            source: "file:" + path + "/res/img/theme.png"

//            MouseArea {
//                anchors.fill: parent

//                onClicked: {
//                    dialogSetTheme.visible = true
//                }
//            }
//        }
    }
}
