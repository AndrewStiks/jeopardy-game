const { WebSocketServer } = require('ws');

const wss = new WebSocketServer({ port: 8080 });

const games = []
const questions = require('./questions.json')

wss.on('connection', function connection(ws) {
  ws.on('error', console.error);

  ws.on('message', function message(data) {
    console.log('received: %s', data);

    const str = data.toString().split(": ")
    const op = str[0]
    const msg = str[1] || ""

    switch(op) {
      case "new": {
        const newCode = generateGameCode() //создаём новую игру и отправляем код игры клиенту
        const game = {
          code: newCode,
          players: new Set([ws]),
          currentMove: 0
        }
        console.log("new game: " + newCode)
        games.push(game)
        console.log("games")
        ws.send("code: " + newCode) // вот тут отправка
        ws.send("questions: " + JSON.stringify(questions))
        ws.send("this: " + 0)
        break;
      }
      case "connect": { //  пытаемся подключ к игре 
        const gameCode = msg.trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)
          games[idx].players.add(ws)
          Array.from(games[idx].players).forEach(x => {
            x.send("players: " + Array.from(games[idx].players).length)
          })
          console.log(games)
          ws.send("code: " + gameCode)
          ws.send("questions: " + JSON.stringify(questions))
          ws.send("this: " + Array.from(games[idx].players).indexOf(ws)) // подключаемся к игре и получаем номер игрока от сервака
        } else {
          ws.send("error")
        }
        break;
      }
      case "start": { // сообщаем о начале игры и текущ ходе
        const gameCode = msg.trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)

          const playersCopy = new Set(games[idx].players)
          playersCopy.delete(Array.from(games[idx].players)[0])
          playersCopy.delete(Array.from(games[idx].players)[games[idx].currentMove])

          const currentMove = Array.from(games[idx].players).indexOf(Array.from(playersCopy)[Math.floor(Math.random()*playersCopy.size)])
          games[idx].currentMove = currentMove
          // ws.send("current: " + currentMove)
	  Array.from(games[idx].players).forEach(x => { //сервак посылает всем подкл клеинтам чей щас ход
            x.send("current: " + currentMove)
          })
          // new Set().size
        } else {
          ws.send("error")
        }
        break;
      }
	  case "qstn": {
        const gameCode = msg.split("_")[0].trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)
		  
		  const cat = parseInt(msg.split("_")[1])
		  const qstn = parseInt(msg.split("_")[2])

          Array.from(games[idx].players).forEach(x => { // рассылаем инфу о выбранном вопросе  в виде категории и вопроса
            x.send("qstn: " + cat + "_" + qstn)
          })
        } else {
          ws.send("error")
        }
        break;
      }
      default:
        console.log(op, msg)
    }
  });

  ws.send('connection successful');
});

const aGame = {
  code: "",
  players: []
}

function generateGameCode() {
  const possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let text = "";
  for (let i = 0; i < 4; i++) {
      text += possible.charAt(Math.floor(Math.random() * possible.length));
  }
  return text;
}
