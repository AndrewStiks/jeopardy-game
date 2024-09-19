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
            font.pointSize: 70
        }

        TextField {
            id: codeInput
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width / 3
            color: "white"
            placeholderText: "Введите код"
            placeholderTextColor: "white"
        }

        Button {
            id: joinBtn
            text: "Присоединиться"
            Layout.preferredWidth: parent.width / 3
            enabled: codeInput.text.length > 0
            onClicked: {
                console.log("Joining game with code: " + codeInput.text)
                // Add logic to join the game using the code

                socket.sendTextMessage("connect: " + codeInput.text)
            }

            Layout.alignment: Qt.AlignHCenter
            contentItem: Text {
                text: joinBtn.text
                color: "red"  // Set the text color here
                font: joinBtn.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        Button {
            text: "Новая игра"
            Layout.preferredWidth: parent.width / 3
            enabled: socket.status == WebSocket.Open
            onClicked: {
                if (socket.status == WebSocket.Open) {
                    socket.sendTextMessage("new: ")
                }
            }

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
