import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root

    title: "Pleamse feed me with IP address..."
    visible: true
    anchors.centerIn: parent
    modal: true
    closePolicy: Popup.CloseOnEscape

    standardButtons: Dialog.Ok



    onAccepted: {
        var fullIp = ipOne.text + "."
                + ipTwo.text + "."
                + ipThree.text + "."
                + ipFour.text

        bServer.connect(fullIp, port.text)
        dirView.selection = []
        fillModel()
    }

    Row {
        id: rowIps
        spacing: 5

        Label {
            id: ftpLabel
            anchors.verticalCenter: ipOne.verticalCenter
            text: "por://"
            font.pixelSize: 18
        }

        TextField {
            id: ipOne
            width: 30
            placeholderText: "192"
            maximumLength: 3

            onTextChanged: {
                if (text.length == 3) { ipTwo.focus = true }
            }

            KeyNavigation.right: ipTwo
            Keys.onReturnPressed: root.accept()

            Component.onCompleted: {
                inputMask: "999"
            }
        }

        Label {
            text: "."
            anchors.verticalCenter: ipOne.verticalCenter
        }

        TextField {
            id: ipTwo
            width: 30
            placeholderText: "168"
            maximumLength: 3

            onTextChanged: {
                if (text.length == 3) { ipThree.focus = true }
            }

            KeyNavigation.right: ipThree
            KeyNavigation.left: ipOne
            Keys.onReturnPressed: root.accept()

            Component.onCompleted: {
                inputMask: "999"
            }
        }

        Label {
            text: "."
            anchors.verticalCenter: ipOne.verticalCenter
        }

        TextField {
            id: ipThree
            width: 30
            placeholderText: "..."
            maximumLength: 3

            onTextChanged: {
                if (text.length == 3) { ipFour.focus = true }
            }

            Keys.onReturnPressed: root.accept()

            Component.onCompleted: {
                inputMask: "999"
            }
        }

        Label {
            text: "."
            anchors.verticalCenter: ipOne.verticalCenter
        }

        TextField {
            id: ipFour
            width: 30
            placeholderText: "..."
            maximumLength: 3

            onTextChanged: {
                if (text.length == 3) { port.focus = true }
            }

            KeyNavigation.right: port
            KeyNavigation.left: ipThree
            Keys.onReturnPressed: root.accept()

            Component.onCompleted: {
                inputMask: "999"
            }
        }

        Label {
            id: colon
            text: ":"
            anchors.verticalCenter: ipOne.verticalCenter
        }

        TextField {
            id: port
            width: 40
            placeholderText: "2121"
            maximumLength: 4

            KeyNavigation.left: ipFour
            Keys.onReturnPressed: root.accept()

            Component.onCompleted: {
                inputMask: "9999"
            }
        }
    }
}



