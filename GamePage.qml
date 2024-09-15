import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Page {
    id: gamePage

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    property var colors: ["#5BC0EB", "#FDE74C", "#9BC53D", "#C3423F"]


    footer: ColumnLayout {
        width: parent.width

        Row {
            Layout.alignment: Qt.AlignHCenter
            // anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Начать"
                onClicked: socket.sendTextMessage("start: " + code)
            }
        }

        ListView {
                width: parent.width
                height: 100
                model: players
                delegate: Rectangle {
                    width: 100; height: 100
                    color: colors[playerId]

                    border.color: "yellow"
                    border.width: playerId == thisPlayerNum ? 3 : 0

                    Text {
                        anchors.centerIn: parent
                        text: playerName.toUpperCase()
                        font.pointSize: 26
                    }

                    Rectangle {
                        visible: playerId == currentMove
                        width: 100
                        height: 10
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }
                }
                spacing: (parent.width - players.count * 100) / (players.count - 1)
                orientation: Qt.Horizontal
            }
    }

    ColumnLayout {

        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Код игры: <b>" + code + "</b>    Игроков: " + players.count
            color: "red"
            font.pointSize: 20
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            columns: 4
            Repeater {
                id: catRep
                model: categories
                delegate: Repeater {
                    id: qstnRep
                    model: qstnNum + 1
                    delegate: Rectangle {
                        border.color: "white"
                        border.width: 2
                        property string qstn: ""
                        color: "transparent"
                        width: 100
                        height: 100
                        Text {
                            text: qstn
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                            font.pointSize: 26
                            color: "white"
                        }
                    }
                }
            }
        }

        Button {
            text: "Back"
            onClicked: {
                stack.pop()
                players.clear()
                players.append({
                                   playerId: 0,
                                   playerName: "Вед"
                               })
            }

            Layout.alignment: Qt.AlignHCenter
        }

    }

    function populateGrid() {
        for (let i = 0; i < categories; i++) {
            catRep.itemAt(i).itemAt(0).qstn = questions[i]["category"]
            for (let j = 1; j < qstnNum + 1; j++) {
                catRep.itemAt(i).itemAt(j).qstn = questions[i]["questions"][j - 1]["cost"]
            }
        }
    }
}
