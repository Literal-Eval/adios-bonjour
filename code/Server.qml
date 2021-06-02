import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Window {
    id: rootServer

    visible: true
    width: 400; height: 530
    title: "Phone"

    property var colorBLACK: Qt.rgba(0, 0, 0, 1)
    property var colorDARK: Qt.rgba(0.157, 0.157, 0.157, 1)
    property var colorGRAY: Qt.rgba(0.843, 0.843, 0.843, 1)
    property var colorLIGHT: Qt.rgba(1, 1, 1, 1)

    property var backColor: colorBLACK
    property var backMode: "dark"
    property var frontColor: (backMode === "light") ? "black": "white"

    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint

    Rectangle {
        id: back
        anchors.fill: parent
        color: backColor
    }

    GetIp {
        id: dialogGetIp
    }

    TitleBar {
        id: titleBar
        titleText: "Server"
        targetWin: rootServer
    }

    DrawerServer {
        id: drawer
    }

    TypeDenoter {
        id: typeDenoter
        anchors.top: addressBar.bottom
        anchors.left: dirView.left
    }

    AddressBar {
        id: addressBar
        actionWindow: bServer
        anchors.topMargin: 40
    }

    FileViewServer {
        id: dirView
        anchors.top: typeDenoter.bottom
    }

    Footer {
        id: footer
        actionWindow: bServer
        anchors.top: dirView.bottom
        anchors.topMargin: 15
    }

    ProgressBar {
        id: progress

        from: 0; to: 100
        height: 5; width: 120
        value: 0
        anchors.top: footer.top
        anchors.topMargin: 7
        anchors.left: parent.left
        anchors.leftMargin: 70

        visible: false
    }

    Connections {
        target: bServer

        function onLsDone()
        {
            var fileInfo;
            var count = bServer.countDir()

            for (var i = 0; i < count; i++)
            {
                fileInfo = bServer.getFileInfo();
                if (fileInfo[0] === "") { break; }
                dirView.model.append({"name": fileInfo[0],
                                     "size": fileInfo[1],
                                     "type": fileInfo[2],
                                     "sizeType": fileInfo[3],
                                     "ext": fileInfo[4],
                                     "selected": false})
            }

            bServer.setCurFile(0)
        }

        function onSetDownloadProgress(percentage)
        {
            progress.value = percentage
        }

        function onDownloadComplete()
        {
            progress.value = 0
            progress.visible = false
            fillModel()
        }

        function onShowProgress()
        {
            progress.visible = true
        }

        function onUploadComplete()
        {
            fillModel()
            progress.visible = false
        }
    }

    function fillModel()
    {
        dirView.model.clear()
        dirView.contentY = 0
        bServer.ls();
    }
}



