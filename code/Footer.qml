import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: foot

    width: parent.width
    height: 32
    color: backColor

    property var actionWindow;
    property var dislocationMode;
    property var clipboard: []
    property var clipboardCount: 0

    Image {
        id: buttChooseColorMode

        width: 24; height: 24
        anchors {
            left: parent.left
            leftMargin: 30
            top: parent.top
        }

        source: "file:///" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/color.png"

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
                if (backMode === "dark")
                {
                    backMode = "light"
                    backColor = colorLIGHT
                }

                else
                {
                    backMode = "dark"
                    backColor = colorDARK
                }
            }
        }
    }

    Image {
        id: buttPaste

        width: 24; height: 24
        anchors {
            right: parent.right
            rightMargin: 30
            top: parent.top
        }

        source: "file:///" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/paste.png"

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

                if (actionWindow === bClient && Backend.getFileType() === "client")
                {
                    bClient.dislocate(Backend.getClipboard(),
                                      Backend.getDislocationType())
                }

                else if (actionWindow === bClient && Backend.getFileType() === "server")
                {
                    bServer.fillQueu(Backend.getClipboard(),
                                     Backend.getDislocationType(),
                                     bClient.curDir())
                    bServer.showProgress()
                }

                else if (actionWindow === bServer && Backend.getFileType() === "client")
                {
                    bServer.fillQueu(Backend.getClipboard(),
                                     "upload",
                                     bClient.curDir())
                    bServer.showProgress()
                }

                Backend.clearClipboard()
            }
        }
    }

    Rectangle {
        id: clipboardCountRect

        width: 20; height: 15
        radius: 4
        color: frontColor

        anchors {
            right: buttPaste.right
            bottom: buttPaste.bottom
            rightMargin: -10
            bottomMargin: -7
        }

        visible: (clipboardCount !== 0)

        Text {
            id: counter
            text: clipboardCount
            color: backColor
            anchors.centerIn: parent
        }
    }

    Image {
        id: buttCut

//        sourceSize.width: 24; sourceSize.height: 24
        width: 24; height: 24
        anchors {
            right: buttPaste.left
            rightMargin: 20
            top: parent.top
        }

        source: "file:///" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/cut.png"

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
                dislocate("cut")
            }
        }
    }

    Image {
        id: buttCopy

//        sourceSize.width: 24; sourceSize.height: 24
        width: 24; height: 24
        anchors {
            right: buttCut.left
            rightMargin: 20
            top: parent.top
        }

        source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/copy.png"

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
                dislocate("copy")
            }
        }
    }

    Image {
        id: buttClearSelection

//        sourceSize.width: 24; sourceSize.height: 24
        width: 24; height: 24
        anchors {
            right: buttCopy.left
            rightMargin: 20
            top: parent.top
        }

        source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/clear.png"

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
                Backend.clearClipboard()
            }
        }
    }

    Rectangle {
        id: hoverInfo

        width: 32; height: 32
        radius: 5
        color: Qt.rgba(0.784, 0.784, 0.784, 0.3)
        visible: false
    }

    Rectangle {
        id: notSelectableInfoCopy

        x: buttCopy.x - 4; y: buttCopy.y - 4
        width: 32; height: 32
        radius: 5
        color: Qt.rgba(0.3, 0.3, 0.3, 0.8)
        visible: true
    }

    Rectangle {
        id: notSelectableInfoCut

        x: buttCut.x - 4; y: buttCut.y - 4
        width: 32; height: 32
        radius: 5
        color: Qt.rgba(0.3, 0.3, 0.3, 0.8)
        visible: notSelectableInfoCopy.visible
    }

    function dislocate(mode)
    {
        if (notSelectableInfoCopy.visible) { return }

        dislocationMode = mode
        clipboard = dirView.selection

        if (actionWindow === bServer) { bServer.setClipDir() }
        else
        {
            var count = bClient.getListDir();
            var fileInfo, files = [];

            for (var i = 0; i < count; i++)
            {
                fileInfo = bClient.getFileInfo();
                files[i] = fileInfo[5]
            }

            bServer.setClipDirClient(files)
            bClient.setCurFile(0)
            bClient.setClipDir()
        }

        Backend.setClipboard(clipboard,
                             (actionWindow === bClient) ? "client": "server",
                             dislocationMode)

        Backend.clipboardChanged(mode)
    }

    Connections {
        target: Backend

        function onClipboardChanged(mode)
        {
            clipboardCount = Backend.getCount();
            if (clipboardCount != 0) { clipboard = ["filled"] }
        }

        function onClipboardCleared()
        {
            clipboard = []
            clipboardCount = 0

            for (var i = 0; i < dirView.model.count; i++)
            {
                dirView.model.get(i)["selected"] = false
            }
        }
    }

    Connections {
        target: dirView

        function onSelectionChanged()
        {
            if (clipboardCount != 0) { return }
            notSelectableInfoCopy.visible = !(clipboardCount === 0
                                             || dirView.selection.length === 0)
        }
    }

    Connections {
        target: foot

        function onClipboardChanged()
        {
            notSelectableInfoCopy.visible = !(clipboardCount === 0
                                             || dirView.selection.length === 0)
        }
    }
}










