import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Page {
    id: qstnPage

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    property var colors: ["#5BC0EB", "#FDE74C", "#9BC53D", "#C3423F"]
    property int cellWidth: (width - 30) / 4

    footer: ColumnLayout {
        width: parent.width

        ListView {
                width: parent.width
                height: cellWidth
                model: players
                delegate: Rectangle {
                    width: cellWidth; height: width
                    color: colors[playerId]

                    border.color: "magenta"
                    border.width: playerId == thisPlayerNum ? 3 : 0

                    Column {
                        anchors.centerIn: parent
                        Text {
                            text: playerName.toUpperCase()
                            font.pointSize: 26
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            visible: playerName.toUpperCase() !== "ВЕД"
                            text: playerScore
                            font.pointSize: 16
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    Rectangle {
                        visible: playerId == currentMove
                        width: cellWidth
                        height: 10
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }
                }
                spacing: (parent.width - players.count * cellWidth) / (players.count - 1)
                orientation: Qt.Horizontal
            }
    }

    ColumnLayout {

        anchors.centerIn: parent
        spacing: 20
        width: parent.width

        Text {
            text: selectedCat
            font.pointSize: 50
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: parent.width
        }

        Text {
            text: selectedCost
            font.pointSize: 20
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            text: selectedQstn
            font.pointSize: 40
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: parent.width
        }

        Text {
            text: selectedAns
            visible: thisPlayerNum == 0
            font.pointSize: 20
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: parent.width
        }

        Text {
            id: playersAnswerText
            text: playersAnswer
            visible: thisPlayerNum == 0
            font.pointSize: 20
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.preferredWidth: parent.width
        }

        TextField {
            id: answerInput
            visible: thisPlayerNum == currentMove
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width / 2
            color: "white"
            placeholderText: "Ответ"
            placeholderTextColor: "white"
        }

        Button {
            visible: thisPlayerNum == currentMove
            Layout.alignment: Qt.AlignHCenter
            text: "Ответить"
            onClicked: {
                socket.sendTextMessage("answer: " + code + "_" + answerInput.text)
            }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20
            Button {
                visible: thisPlayerNum == 0
                Layout.alignment: Qt.AlignHCenter
                text: "Да"
                onClicked: {
                    socket.sendTextMessage("next: " + code + "_yes")
                }
            }
            Button {
                visible: thisPlayerNum == 0
                Layout.alignment: Qt.AlignHCenter
                text: "Нет"
                onClicked: {
                    socket.sendTextMessage("next: " + code + "_no")
                }
            }
        }
    }
}
