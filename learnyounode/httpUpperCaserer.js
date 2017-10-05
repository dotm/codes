const http = require('http')
const map = require('through2-map')
let port = Number(process.argv[2]);

function requestHandler(req,res){
  if (req.method !== 'POST') {
    return res.end('send me a POST\n')
  }

	req.pipe(map(function (chunk) {
    return chunk.toString().toUpperCase()
  })).pipe(res)
}

let server = http.createServer(requestHandler);
server.listen(port)
