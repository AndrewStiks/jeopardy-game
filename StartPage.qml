import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebSockets

Page {

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
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
            text: "Присоединиться"
            enabled: codeInput.text.length > 0
            onClicked: {
                console.log("Joining game with code: " + codeInput.text)
                // Add logic to join the game using the code

                socket.sendTextMessage("connect: " + codeInput.text)
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
            text: "Новая игра"
            enabled: socket.status == WebSocket.Open
            onClicked: {
                if (socket.status == WebSocket.Open) {
                    socket.sendTextMessage("new:")
                }
            }

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
