import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {

    width: parent.width
    height: 32
    color: colorDARK

    Image {
        id: buttPaste

        width: 16; height: 16
        anchors {
            right: parent.right
            rightMargin: 20
            top: parent.top
        }

//        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/paste.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {

            }
        }
    }

    Image {
        id: buttCut

        sourceSize.width: 16; sourceSize.height: 16
        anchors {
            right: buttPaste.left
            rightMargin: 20
            top: parent.top
        }

        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/cut.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {

            }
        }
    }

    Image {
        id: buttCopy

        sourceSize.width: 16; sourceSize.height: 16
        anchors {
            right: buttCut.left
            rightMargin: 20
            top: parent.top
        }

        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/copy.ico"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onHoveredChanged: {
                if (containsMouse)
                {
                    hoverInfo.visible = true
                    hoverInfo.x = parent.x - 4; hoverInfo.y = parent.y - 4
                }
                else
                {
                    hoverInfo.visible = false
                }
            }

            onClicked: {

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
}



