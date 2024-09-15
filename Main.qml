import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebSockets

ApplicationWindow {
    visible: true
    title: "Своя игра"

    // FontLoader {
    //     id: gameFont
    //     source: "qrc:/font/futura.otf"
    // }

    font.family: "Futura Condensed PT"
    font.pointSize: 20

    background: Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#180088"
            }
            GradientStop {
                position: 1
                color: "#3011aa"
            }
        }
    }

    StackView {
        id: stack
        anchors.centerIn: parent
        width: parent.width
        height: parent.height * 0.8

        initialItem: startPage
    }

    property string code: "value"
    property var questions: []
    property int categories: 3
    property int qstnNum: 3

    property int thisPlayerNum: 0
    property int currentMove: 0


    ListModel {
        id: players
        ListElement {
            playerId: 0
            playerName: "Вед"
        }
    }

    StartPage {
        id: startPage
    }
    GamePage {
        id: gamePage
        visible: false
    }

    Row {
        spacing: 10
        anchors.bottom: parent.bottom
        Label {
            id: connectionLbl
            text: socket.status == WebSocket.Open ? "connected" : "disconnected"
        }
        Rectangle {
            id: connectionInd
            color: socket.status == WebSocket.Open ? "green" : "red"
            width: 10
            height: 10
            radius: 5
        }
        Button {
            text: "Connect"
            onClicked: {
                if (socket.active) {
                    socket.active = false
                    socket.active = true
                }
            }
        }
    }

    WebSocket {
        id: socket
        url: "ws://195.135.253.4:8080"
        // url: "ws://192.168.3.69:8080"
        onTextMessageReceived: function(message) {
            connectionLbl.text = "Received message: " + message.slice(0, 10)
            console.log(message)

            const str = message.toString().split(":")
            const op = str[0]
            const msg = str[1] || ""

            switch(op) {
            case "code": {
                code = message.split("code: ")[1]
                stack.push(gamePage)
                break;
            }
            case "questions": {
                questions = JSON.parse(message.split("questions: ")[1])
                gamePage.populateGrid()
                break;
            }
            case "this": {
                thisPlayerNum = parseInt(msg)
                break;
            }
            case "current": {
                currentMove = parseInt(msg)
                console.log(currentMove)
                break;
            }
            case "players": {
                for (var i = players.count; players.count < parseInt(msg); i++) {
                    players.append({playerId: i, playerName: "Игр " + i})
                }

                break;
            }

            default:
                console.log(op, msg)
            }
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                         } else if (socket.status == WebSocket.Closed) {
                             connectionLbl.text += "\nSocket closed"
                         }
        active: true
    }
}
