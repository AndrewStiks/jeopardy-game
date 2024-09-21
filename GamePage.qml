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
    property int cellWidth: (width - 30) / 4


    footer: ColumnLayout {
        width: parent.width

        Button {
            visible: thisPlayerNum == 0
            enabled: players.count > 2
            text: "Начать"
            Layout.alignment: Qt.AlignHCenter
            onClicked: { //при жмаке кнопке начать ведущий скрывает кнопку и отправляем на сервер сообщ о начале игры
                if (thisPlayerNum == 0) { //онли ведущий может переключ очередь игрока при афк
                    text = "Сменить игрока"
                } else {
                    visible = false
                }
                socket.sendTextMessage("next: " + code + "_skip")
            }
        }

        ListView { //отображение игроков  рамка для текущ игрока и его имени
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

        Text {
            text: "Код игры: <b>" + code + "</b>    Игроков: " + players.count
            color: "red"
            font.pointSize: 20
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: cellWidth
            font.pointSize: 30
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            ColumnLayout {
                Repeater { // повторяем для категорий в игре параметры ДИНАМИЧЕСКОЕ СОЗДАНИЕ. и отправка после клика на сервер
                    id: catRep
                    model: categories
                    delegate: Rectangle {
                        border.color: "white"
                        border.width: 2
                        property string qstn: ""
                        color: "transparent"
                        width: cellWidth
                        height: width
                        Text {
                            text: questions[index]["category"]
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                            font.pointSize: 26
                            color: "white"
                            width: cellWidth
                            wrapMode: Text.WordWrap
                        }
                    }
                }

            }
            GridLayout { // сетка с вопросами 
                columns: 3
                Repeater {
                    id: qstnRep
                    model: qstnNum * 3
                    delegate: Rectangle {
                        border.color: "white"
                        border.width: 2
                        property string qstn: ""
                        color: "transparent"
                        width: cellWidth
                        height: width
                        Text {
                            text: questions[Math.floor(index / 3)]["questions"][index % 3]["cost"]
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                            font.pointSize: 26
                            color: "white"
                        }

                        MouseArea { // отобр вопроса и оболасть клика для выбора
                            anchors.fill: parent
                            enabled: currentMove == thisPlayerNum
                            onClicked: {
                                socket.sendTextMessage("qstn: " + code + "_" + Math.floor(index / 3) + "_" + index % 3)
                            }
                        }
                    }
                }
            }
        }

    }
}
