import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.qmlmodels 1.0

Window {
    id: rootClient

    property var colorBLACK: Qt.rgba(0, 0, 0, 1)
    property var colorDARK: Qt.rgba(0.157, 0.157, 0.157, 1)
    property var colorGRAY: Qt.rgba(0.843, 0.843, 0.843, 1)
    property var colorLIGHT: Qt.rgba(1, 1, 1, 1)

    property var backColor: colorDARK
    property var backMode: "dark"
    property var frontColor: (backMode === "light") ? "black": "white"

    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint

    visible: true
    width: 870; height: 530
    title: "PC"

    Rectangle {
        id: back
        anchors.fill: parent
        color: backColor
    }

    QuickAccess {
        id: quickAccess
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
    }

    TitleBar {
        id: titleBar
        titleText: "Windoge"
        targetWin: rootClient
    }

    DrawerClient {
        id: drawer
    }

    SetTheme {
        id: dialogSetTheme
        f: footer
    }

    ColorPicker {
        id: diaColPick
    }

    About {
        id: dialogAbout
    }

    AddressBar {
        id: addressBar
        actionWindow: bClient
        anchors.topMargin: 40
    }

    TypeDenoter {
        id: typeDenoter
        anchors.top: addressBar.bottom
        anchors.left: dirView.left
    }

    FileViewClient {
        id: dirView
        anchors.top: typeDenoter.bottom
        f: footer
    }

    Footer {
        id: footer
        actionWindow: bClient
        anchors.top: dirView.bottom
        anchors.topMargin: 15

        Component.onCompleted: {
            setColor()
            rootClient.update()
        }
    }

    ProgressBar {
        id: progress

        from: 0; to: 100
        height: 5; width: 200
        value: 0
        anchors.verticalCenter: titleBar.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20

        visible: false
    }

    Component.onCompleted: {
        fillModel()
    }

    Connections {
        target: bClient
    }

    Connections {
        target: bServer

        function onSetUploadProgress(percentage)
        {
            progress.value = percentage
        }

        function onUploadComplete()
        {
            progress.value = 0
            progress.visible = false
            fillModel()
        }

        function onShowProgress()
        {
            progress.visible = true
        }

        function onDownloadComplete()
        {
            fillModel()
            progress.visible = false
        }
    }

    function fillModel()
    {
        dirView.model.clear()
        dirView.contentY = 0
        var count = bClient.getListDir();
        var fileInfo;

        for (var i = 0; i < count; i++)
        {
            fileInfo = bClient.getFileInfo();
            dirView.model.append({"name": fileInfo[0],
                                 "size": fileInfo[1],
                                 "lastModified": fileInfo[2],
                                 "type": fileInfo[3],
                                 "sizeType": fileInfo[4],
                                 "ext": fileInfo[6],
                                 "selected": false})
        }

        bClient.setCurFile(0)
    }
}


