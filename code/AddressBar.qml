import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: addressBar

    property var currentAddress: ""
    property var actionWindow;

    width: parent.width; height: 16
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.top: parent.top
    color: colorDARK

    Image {
        id: buttCdUp

        width: 16; height: 16
        anchors {
            left: parent.left
            leftMargin: 30
        }

        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/arrowLeft.ico"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                actionWindow.cdUp()
                fillModel()
                var cAddress = actionWindow.curDir()
                currentAddress = cAddress
            }
        }
    }

    Image {
        id: buttCdDown

        width: 16; height: 16
        anchors {
            left: buttCdUp.right
            top: parent.top
        }

        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/arrowRight.ico"

        MouseArea {
            anchors.fill: parent

            onClicked: {

            }
        }
    }

    Image {
        id: iconFolderAddressBar

        width: 16; height: 16
        anchors.left: buttCdDown.right
        anchors.leftMargin: 10
        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/folderHead.ico"
    }

    Label {
        id: addressText

        text: currentAddress
        anchors.leftMargin: 20
        anchors.left: iconFolderAddressBar.right
        color: 'white'
        font.pixelSize: 12
    }

    Image {
        id: iconRefresh

        anchors.right: parent.right
        anchors.rightMargin: 20
        source: "file:E:/Codes/MyCodes/CPP/QML/build-myQFtp-Desktop_Qt_5_15_2_MinGW_64_bit-Release/res/img/refresh.ico"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                fillModel()
            }
        }
    }

    Component.onCompleted: {
        var cAddress = actionWindow.curDir()
        currentAddress = cAddress
    }
}

