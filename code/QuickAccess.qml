import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    width: 130; height: 320
    color: backColor

    Column {

        width: parent.width; height: parent.height
        spacing: 10

        Rectangle {
            width: parent.width
            height: 24
            color: backColor

            Image {
                id: iconPC
                width: 24; height: 24
                source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/PC.ico"
            }

            Label {
                id: labelDrives
                text: "My PC"
                color: frontColor
                anchors.left: iconPC.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                font {
                    family: "Calibri"
                    pointSize: 12
                }
            }
        }

        ListView {
            id: drives
            width: parent.width
            height: driveModel.count * 16 + 16
            spacing: 5
            boundsMovement: Flickable.StopAtBounds

            model: ListModel {
                id: driveModel
            }

            delegate: Rectangle {
                width: parent.width
                height: 16
                color: backColor

                Rectangle {
                    id: selectionNotify

                    width: parent.width + 4
                    radius: 5
                    x: parent.x
                    color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.15): Qt.rgba(0, 0, 0, 0.15)
                    height: 16
                    visible: false
                }

                Rectangle {
                    id: hoverInfo

                    width: parent.width + 4
                    radius: 5
                    x: parent.x
                    color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.1): Qt.rgba(0, 0, 0, 0.1)
                    height: 16
                    visible: false
                }

                Image {
                    id: icon
                    width: 16; height: 16
                    source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/drive.ico"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                Text {
                    text: driveName
                    color: frontColor
                    anchors.left: icon.right
                    anchors.leftMargin: 10
                    font.family: "Calibri"
                    font.pointSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onHoveredChanged: {
                        hoverInfo.visible = !hoverInfo.visible
                    }

                    onClicked: {
                        bClient.setCurDir(driveName)
                        fillModel()
                        addressBar.currentAddress = driveName
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 24
            color: backColor

            Image {
                id: iconLibrary
                width: 24; height: 24
                source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/libraries.ico"
            }

            Label {
                id: labelLibrary
                text: "Libraries"
                color: frontColor
                anchors.left: iconLibrary.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                font: labelDrives.font
            }
        }

        ListView {
            id: libraries
            width: parent.width
            height: libModel.count * 16 + 20
            spacing: 5
            boundsMovement: Flickable.StopAtBounds

            model: ListModel {
                id: libModel
            }

            delegate: Rectangle {
                width: parent.width
                height: 16
                color: backColor

                Rectangle {
                    id: selectionNotifyLib

                    width: parent.width
                    radius: 5
                    x: parent.x
                    color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.15): Qt.rgba(0, 0, 0, 0.15)
                    height: 16
                    visible: false
                }

                Rectangle {
                    id: hoverInfoLib

                    width: parent.width
                    radius: 5
                    x: parent.x
                    color: (backMode === "dark") ? Qt.rgba(1, 1, 1, 0.1): Qt.rgba(0, 0, 0, 0.1)
                    height: 16
                    visible: false
                }

                Image {
                    id: icons
                    width: 16; height: 16
                    source: "file:" + path + "/res/img/" + ((backMode === "light") ? "light": "dark") + "/" + name + ".ico"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                Text {
                    text: name
                    color: frontColor
                    anchors.left: icons.right
                    anchors.leftMargin: 10
                    font.family: "Calibri"
                    font.pointSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onHoveredChanged: {
                        hoverInfoLib.visible = !hoverInfoLib.visible
                    }

                    onClicked: {
                        bClient.setCurDir(libPath)
                        fillModel()
                        addressBar.currentAddress = libPath
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        var drives = bClient.getDrivesList()
        driveModel.clear()
        for (var i = 0; i < drives.length; i++)
        {
            driveModel.append({"driveName": drives[i]})
        }

        var libraries = bClient.getLibraryList()
        var shortNames = ["Desktop", "Documents", "Music", "Pictures", "Movies"]
        libModel.clear()
        for (i = 0; i < 5; i++)
        {
            libModel.append({"name": shortNames[i],
                            "libPath": libraries[i],
                            "selected": false})
        }
    }
}
