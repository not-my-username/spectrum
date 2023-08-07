const WebSocketServer = require('ws');
const wss = new WebSocketServer.Server({ port: 8888 })

var WebSocket = require('ws');
var client = new WebSocket('ws://localhost:9999/qlcplusWS');

wss.on("connection", ws => {
    ws.on("message", data => {
        console.log(`Client has sent us: ${data}`)
        client.send(data.toString());
    });

});
console.log("The WebSocket server is running on port 8888")



