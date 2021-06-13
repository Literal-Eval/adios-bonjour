import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Page {
    id: pageAbout

    Flickable {

        width: parent.width; height: parent.height - 10
        contentWidth: parent.width; contentHeight: 1000
        clip: true

        Image {
            id: aboutLogo

            width: 140; height: 140
            source: "qrc:/res/img/bigIcon.png"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 20
            }
        }

        Text {
            id: labCopyright

//            width: parent.width - 40
            anchors {
                top: aboutLogo.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            text: "<h3>(C) Ravi Dev Pandey</h3>"
            wrapMode: Text.WrapAnywhere
        }

        Text {

            width: parent.width - 40
            anchors {
                top: labCopyright.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }

            text: "<h4>Backend</h4>" +
                  "Written completely in C++, using Qt." +
                  "<br><h4>Network</h4>" +
                  "Portage uses TCP connection to communicate between server and client. " +
                  "<br><b>This is not FTP.</b><br>Now you may be like, wait what ? Doesn't FTP " +
                  "use TCP internally ? Yes it does, but the special handshakes that FTP uses " +
                  "are not used here, and it's pure TCP server. So what does that even mean ? " +
                  "It means that you won't be able to use this app as a normal FTP server, " +
                  "and no FTP client would be able to communicate with it." +
                  "<br>So, you can only use this app with Portage PC. Sed lyf, I know." +
                  "<br><h4>Front End</h4>" +
                  "Written in QtQuick / QML and JavaScript." +
                  "<br><h4>Contributors</h4>" +
                  "Goyir Koyu and Priyanshu Singh for extensive and elaborate testing of both " +
                  "sides of the app (PC and Android), and providing better design ideas."

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
}







