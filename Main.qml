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

    onClosing: {
        if(stack.depth > 1){
            close.accepted = false
            stack.pop();
        }else{
            return;
        }
    }

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

    property string selectedCat: ""
    property int selectedCost: 0
    property string selectedQstn: ""
    property string selectedAns: ""


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
    Component {
        id: gamePage
        GamePage {
        }
    }
    Component {
        id: qstnPage
        QstnPage {
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        width: parent.width
        Button {
            id: connectBtn
            text: socket.active ? "Reconnect" : "Connect"
            Layout.alignment: Qt.AlignHCenter

            contentItem: Text {
                text: connectBtn.text
                color: socket.active ? "green" : "red"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: connectBtn.font
            }

            onClicked: {
                socket.active = false
                socket.active = true
            }
        }
    }

    WebSocket {
        id: socket
        url: "ws://195.135.253.4:8080"
        // url: "ws://192.168.3.69:8080"
        // url: "ws://192.168.224.242:8080"
        onTextMessageReceived: function(message) { //на сообщение от сервера 
            // connectionLbl.text = "Received message: " + message.slice(0, 10)
            console.log(message)

            const str = message.toString().split(": ") //сообщение разделяем на оп - операция и msg - сообщение
            const op = str[0]
            const msg = str[1] || ""

            switch(op) {
            case "code": {
                code = msg
                stack.push(gamePage)
                break;
            }
            case "questions": {
                questions = JSON.parse(msg) //например если вопросы надо парс объекта сделать этого
                break;
            }
            case "this": {
                thisPlayerNum = parseInt(msg)
                break;
            }
            case "current": { //принимаем номер игрока текущего
                currentMove = parseInt(msg)
                console.log("current: " + currentMove)
                if (stack.depth > 2) { //глубина стека 3 если 
                    stack.pop()
                }

                break;
            }
            case "players": {
                for (var i = players.count; players.count < parseInt(msg); i++) {
                    players.append({playerId: i, playerName: "Игр " + i})
                }

                break;
            }
            case "qstn": { //принимает индекс категории вопроса и из глоб перемен записывается
                const cat = parseInt(msg.split("_")[0])
                const qstn = parseInt(msg.split("_")[1])

                selectedCat = questions[cat]["category"]
                selectedCost = questions[cat]["questions"][qstn]["cost"]
                selectedQstn = questions[cat]["questions"][qstn]["text"]
                selectedAns = questions[cat]["questions"][qstn]["answer"]

                stack.push(qstnPage)//кидает всех игроков на страницу вопроса после отправки сервера индексов игрокам
                break;
            }

            default:
                console.log(op, msg)
            }
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                             socket.active = false
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                         } else if (socket.status == WebSocket.Closed) {
                             // connectionLbl.text += "\nSocket closed"
                             socket.active = false
                         }
        active: true
    }
}
