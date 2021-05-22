import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Window {
    id: rootServer

    visible: true
    width: 400; height: 530
    title: "Phone"

    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint

    Rectangle {
        id: back

        anchors.fill: parent
        color: Qt.rgba(0.157, 0.157, 0.157, 255)
    }

    TitleBar {
        id: titleBar
        titleText: "Server"
        targetWin: rootServer
    }

    TypeDenoter {
        id: typeDenoter

        anchors.top: addressBar.bottom
        anchors.left: currentDir.left
    }

    AddressBar {
        id: addressBar
        actionWindow: bServer
        anchors.topMargin: 40
    }

    FileViewServer {
        id: currentDir
        anchors.top: typeDenoter.bottom
    }

    Footer {
        id: footer

        anchors.top: currentDir.bottom
        anchors.topMargin: 10
    }

    Connections {
        target: bServer

        function onFolderInfoReady()
        {
            var fileInfo;
            var count = bServer.getCurDirTotal()

            for (var i = 0; i < count - 1; i++)
            {
                fileInfo = bServer.getFileInfo();
                currentDir.model.append({"name": fileInfo[0],
                                     "size": fileInfo[1],
                                     "type": fileInfo[2],
                                     "sizeType": fileInfo[3]})
            }

            bServer.setCurFile(0)
        }
    }

    function fillModel()
    {
        currentDir.model.clear()
        currentDir.contentY = 0
        bServer.getListDir();
    }
}




