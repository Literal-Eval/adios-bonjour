import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    width: 400; height: 600
    visible: true
    title: qsTr("Portage")

    property var serverRunning: false

    header: Rectangle {
        id: head
        width: parent.width
        height: 60
        color: Qt.rgba(41/255, 121/255, 255/255, 1)
        radius: 2

        Image {
            width: 32; height: 32
            source: "qrc:/res/img/settings.png"
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: drawer.open()
            }
        }

        Text {
            text: "Portage"
            anchors.centerIn: parent
            color: 'white'

            font {
                family: "Impact"
                pointSize: 25
            }
        }
    }

    SwipeView {
        id: pages

        anchors.fill: parent
        currentIndex: foot.currentIndex

        PageHome {}

        PageChats {}

        PageLogs {}

        PageAbout {}
    }

    footer: Label {

        width: parent.width
        height: 60

        PageIndicator {
            id: foot

            property var imgs: ["Home", "Chat", "Log", "Info"]

            interactive: true
            count: pages.count
            currentIndex: pages.currentIndex
            anchors.centerIn: parent

            delegate: Label {

                width: 75; height: 60

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#affdd835"
                    visible: (index == pages.currentIndex)
                }

                Image {
                    width: 32; height: 32
                    source: "qrc:/res/img/" + foot.imgs[index] + ".png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                }

                Label {
                    id: labFootText

                    text: foot.imgs[index]
                    Material.foreground: Material.Blue

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: 200
        height: parent.height
        edge: Qt.RightEdge

        Material.background: Material.Blue

        Column {
            spacing: 10
            width: 140; height: parent.height

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            Image {
                id: logoDrawer

                width: 140; height: 140
                source: "qrc:/res/img/bigIcon.png"
            }
        }
    }
}







