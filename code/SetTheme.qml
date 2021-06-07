import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root

    anchors.centerIn: parent
    modal: true
    closePolicy: Popup.CloseOnEscape
    title: "Default colors"

    standardButtons: Dialog.Ok

    onAccepted: {
        f.setColor()
    }

    property var f

    Column {
        id: col
        spacing: 10

        Label {
            id: info
            text: "Set the accent color for both modes\n"
        }

        Row {
            spacing: 5
            Label {
                text: "Light"
                width: 50
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: 'white'
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Backend.setTheme("255 255 255 255", "light")
                        }
                    }
                }

                Label {
                    text: "White"
                }
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: Qt.rgba(0.843, 0.843, 0.843, 1)
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Backend.setTheme("215 215 215 255", "light")
                        }
                    }
                }

                Label {
                    text: "Gray"
                }
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: colorLIGHT
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            diaColPick.mode = "light"
                            diaColPick.visible = true
                        }
                    }
                }

                Label {
                    text: "Custom"
                }
            }
        }

        Row {
            spacing: 5
            Label {
                text: "Dark"
                width: 50
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: 'black'
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Backend.setTheme("0 0 0 255", "dark")
                        }
                    }
                }

                Label {
                    text: "Black"
                }
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: Qt.rgba(0.157, 0.157, 0.157, 1)
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Backend.setTheme("40 40 40 255", "dark")
                        }
                    }
                }

                Label {
                    text: "Dark"
                }
            }

            Column {
                spacing: 5
                Rectangle {
                    width: 50; height: 20
                    color: colorDARK
                    border.width: 2
                    border.color: 'black'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            diaColPick.mode = "dark"
                            diaColPick.visible = true
                        }
                    }
                }

                Label {
                    text: "Custom"
                }
            }
        }
    }
}





