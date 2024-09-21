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

    switch (op) {
      case "new": {
        const newCode = generateGameCode()
        const game = {
          code: newCode,
          players: [ws],
          currentMove: 0
        }
        console.log("new game: " + newCode)
        games.push(game)
        console.log("games")
        ws.send("code: " + newCode)
        ws.send("questions: " + JSON.stringify(questions))
        ws.send("this: " + 0)
        break;
      }
      case "connect": {
        const gameCode = msg.trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)
          if (games[idx].players.indexOf(ws) == -1) {
            games[idx].players.push(ws)
          }
          games[idx].players.forEach(x => {
            x.send("players: " + games[idx].players.length)
          })
          console.log(games)
          ws.send("code: " + gameCode)
          ws.send("questions: " + JSON.stringify(questions))
          ws.send("this: " + games[idx].players.indexOf(ws))
        } else {
          ws.send("error")
        }
        break;
      }
      case "next": {
        const gameCode = msg.split("_")[0].trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)

          const masterMove = parseInt(msg.split("_")[1])

          if (masterMove == "skip") {

          } else if (masterMove == "yes") {

          } else if (masterMove == "no") {

          }

          const playersCopy = new Set(games[idx].players)
          playersCopy.delete(games[idx].players[0])
          playersCopy.delete(games[idx].players[games[idx].currentMove])

          const currentMove = games[idx].players.indexOf(Array.from(playersCopy)[Math.floor(Math.random() * playersCopy.size)])
          games[idx].currentMove = currentMove

          games[idx].players.forEach(x => {
            ws.send("current: " + currentMove)
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

          games[idx].players.forEach(x => {
            x.send("qstn: " + cat + "_" + qstn)
          })
        } else {
          ws.send("error")
        }
        break;
      }
      case "answer": {
        const gameCode = msg.split("_")[0].trim().toUpperCase()
        console.log("code: " + gameCode)

        const search = games.filter(x => x.code == gameCode)
        const idx = games.indexOf(search[0])
        if (search.length > 0) {
          console.log("Game found: " + gameCode + ", idx: " + idx)

          const answer = parseInt(msg.split("_")[1])

          games[idx].players.forEach(x => {
            x.send("answer: " + answer)
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
