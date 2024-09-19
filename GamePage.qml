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

        Button {
            visible: true
            enabled: players.count > 2
            text: "Начать"
            Layout.alignment: Qt.AlignHCenter
            onClicked: { //при жмаке кнопке начать ведущий скрывает кнопку и отправляем на сервер сообщ о начале игры
                if (thisPlayerNum == 0) {
                    text = "Сменить игрока"
                } else {
                    visible = false
                }
                socket.sendTextMessage("start: " + code)
            }
        }

        ListView { //отображение игроков  рамка для текущ игрока и его имени
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
                        width: 100
                        height: 100
                        Text {
                            text: questions[index]["category"]
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                            font.pointSize: 26
                            color: "white"
                            width: 100
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
                        width: 100
                        height: 100
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
