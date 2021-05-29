import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

//    Keys {
//        onRightPressed: {
//            if (ipOne.focus) { ipTwo.focus = true }
//            if (ipTwo.focus) { ipThree.focus = true }
//            if (ipThree.focus) { ipFour.focus = true }
//            if (ipFour.focus) { port.focus = true }
//        }

//        onLeftPressed: {
//            if (port.focus) { ipFour.focus = true }
//            if (ipFour.focus) { ipThree.focus = true }
//            if (ipThree.focus) { ipTwo.focus = true }
//            if (ipTwo.focus) { ipOne.focus = true }
//        }
//    }

Dialog {
    id: dia

    title: "Pleamse feed me with IP address..."
    visible: true
    anchors.centerIn: parent
    modal: true

    standardButtons: Dialog.Ok

    onAccepted: {
        var fullIp = ipOne.text + "."
                + ipTwo.text + "."
                + ipThree.text + "."
                + ipFour.text + ":"
                + port.text

        bServer.setIp(fullIp)
        dirView.selection = []
        fillModel()
    }

    Row {
        id: rowIps
        spacing: 5

        Label {
            id: ftpLabel
            anchors.verticalCenter: ipOne.verticalCenter
            text: "ftp://"
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

            Component.onCompleted: {
                inputMask: "9999"
            }
        }
    }
}



