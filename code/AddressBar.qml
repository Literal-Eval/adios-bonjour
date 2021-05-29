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
    color: backColor

    Image {
        id: buttDrawer

        width: 16; height: 16
        anchors {
            left: parent.left
            leftMargin: 5
        }

        source: "file:" + path + "/res/img/settings.ico"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                drawer.open()
            }
        }
    }

    Image {
        id: buttCdUp

        width: 16; height: 16
        anchors {
            left: parent.left
            leftMargin: 30
        }

        source: "file:" + path + "/res/img/arrowLeft.ico"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                actionWindow.cdUp()
                fillModel()
                var cAddress = actionWindow.curDir()
                currentAddress = cAddress

                dirView.selection = []
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

        source: "file:" + path + "/res/img/arrowRight.ico"

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
        source: "file:" + path + "/res/img/folderHead.ico"
    }

    Label {
        id: addressText

        text: currentAddress
        anchors.leftMargin: 20
        anchors.left: iconFolderAddressBar.right
        color: frontColor
        font.pixelSize: 12
    }

    Image {
        id: iconRefresh

        width: 16; height: 16
        anchors.right: parent.right
        anchors.rightMargin: 20
        source: "file:" + path + "/res/img/refreshBlack.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                fillModel()
                dirView.selection = []
                footer.clipboard = []
            }
        }
    }

    Component.onCompleted: {
        var cAddress = actionWindow.curDir()
        currentAddress = cAddress
    }
}

