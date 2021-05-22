import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.qmlmodels 1.0

Window {
    id: rootClient

    property var colorDARK: Qt.rgba(0.157, 0.157, 0.157, 255)
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint

    visible: true
    width: 870; height: 530
    title: "PC"

    Rectangle {
        id: back

        anchors.fill: parent
        color: colorDARK
    }

    TitleBar {
        id: titleBar
        titleText: "Client"
        targetWin: rootClient
    }

    AddressBar {
        id: addressBar
        actionWindow: bClient
        anchors.topMargin: 40
    }

    TypeDenoter {
        id: typeDenoter

        anchors.top: addressBar.bottom
        anchors.left: currentDir.left
    }

    FileViewClient {
        id: currentDir
        anchors.top: typeDenoter.bottom
    }

    Footer {
        id: footer
        anchors.top: currentDir.bottom
        anchors.topMargin: 10
    }

    Component.onCompleted: {
        fillModel()
    }

    function fillModel()
    {
        currentDir.model.clear()
        currentDir.contentY = 0
        var count = bClient.getListDir();
        var fileInfo;

        for (var i = 0; i < count; i++)
        {
            fileInfo = bClient.getFileInfo();
            currentDir.model.append({"name": fileInfo[0],
                                 "size": fileInfo[1],
                                 "lastModified": fileInfo[2],
                                 "type": fileInfo[3],
                                 "sizeType": fileInfo[4]})
        }

        bClient.setCurFile(0)
    }
}


