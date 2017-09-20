const http = require('http')
const fs = require('fs')
let port = Number(process.argv[2]);
let filepath = process.argv[3];

function requestHandler (req, res){
  res.writeHead(200, { 'content-type': 'text/plain' });
  fs.createReadStream(filepath).pipe(res);
}

let server = http.createServer(requestHandler);
server.listen(port)
