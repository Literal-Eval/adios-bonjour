import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root

    anchors.centerIn: parent
    width: 500; height: 400
    title: "Credits..."

    footer: DialogButtonBox {
        Button {
            text: "Nope"
            flat: true
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }

        Button {
            text: "Yems"
            flat: true
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }

    Label {
        text: "<h4>(C) Ravi Dev Pandey, for all the UX, UI and code.</h4>" +
              "<h4>Backend:</h4>" +
              "Backend uses cURL as the FTP client, and a FTP server app as the server.<br>" +
              "For now, the server app is not mine, but in the future versions, it'll <br>" +
              "be completely replaced by my code (hopefully :) ) <br>" +
              "The code uses Qt and C++ as the core languages." +
              "<h4>Front End</h4>" +
              "The UI, UX is written completely in QML." +
              "<h4>The UX</h4>" +
              "- It has been tried to maintain as native look as possible <br>" +
              "- Custom themes allow to change the color as the user wants. <br>" +
              "- The expected android app will have the same UI too. <br>"

        textFormat: Text.RichText
    }
}
