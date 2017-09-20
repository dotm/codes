const http = require('http')
const map = require('through2-map')
let port = Number(process.argv[2]);

function requestHandler(req,res){
  ...
}

let server = http.createServer(requestHandler);
server.listen(port)
