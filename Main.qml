import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebSockets

ApplicationWindow {
    visible: true
    title: "Своя игра"

    background: Rectangle {
        anchors.fill: parent
        color: "#180088"
    }

    // Main vertical layout
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: parent.width

        Text {
            text: "Своя Игра"
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            font.pointSize: 50
        }

        TextField {
            id: codeInput
            width: 800
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width / 2
            color: "white"
            placeholderText: "Введите код"
            placeholderTextColor: "white"
        }

        Button {
            id: myButton
            text: "Join Game"
            enabled: codeInput.text.length > 0
            onClicked: {
                console.log("Joining game with code: " + codeInput.text)
                // Add logic to join the game using the code
            }

            Layout.alignment: Qt.AlignHCenter
            contentItem: Text {
                text: myButton.text
                color: "red"  // Set the text color here
                font: myButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        Button {
            text: "Start New Game"
            enabled: socket.status == WebSocket.Open
            onClicked: {
                var newCode = generateGameCode()
                console.log("New game started with code: " + newCode)
                newGameCode.text = "Game Code: " + newCode
                // Add logic to start a new game and generate a code
                if (socket.status == WebSocket.Open) {
                    socket.sendTextMessage(newCode)
                }
            }

            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            id: newGameCode
            text: "Game Code: -"
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Row {
        spacing: 10
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
            onClicked: socket.active = true
        }
    }

    WebSocket {
        id: socket
        url: "ws://192.168.3.69:8080"
        onTextMessageReceived: function(message) {
            connectionLbl.text = connectionLbl.text + "\nReceived message: " + message
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                         } else if (socket.status == WebSocket.Closed) {
                             connectionLbl.text += "\nSocket closed"
                         }
        active: false
    }

    // Function to generate a random game code
    function generateGameCode() {
        const possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        let text = "";
        for (let i = 0; i < 6; i++) {
            text += possible.charAt(Math.floor(Math.random() * possible.length));
        }
        return text;
    }
}
