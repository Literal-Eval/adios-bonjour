import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Client {
    id: rootClient

    Server {
        id: rootServer
        x: rootClient.x + rootClient.width + 5
        y: rootClient.y
    }
}
