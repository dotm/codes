const http = require('http')
const url = require('url')
let port = Number(process.argv[2]);

function parsetime(time){
  return {
    hour: time.getHours()
      , minute: time.getMinutes()
      , second: time.getSeconds()
  }
}

function unixtime(time){
  return {unixtime: time.getTime()}
}

function requestHandler(req,res){
  const parsedURL = url.parse(req.url, true);
  const time = new Date(parsedURL.query.iso);
  let result;

	if (/^\/api\/parsetime/.test(req.url)) {
    result = parsetime(time)
  } else if (/^\/api\/unixtime/.test(req.url)) {
    result = unixtime(time)
  }

	if (result) {
		res.writeHead(200, {'Content-Type':'application/json'})
		res.end(JSON.stringify(result))
	}else{
		res.writeHead(404)
		res.end()
	}
}

let server = http.createServer(requestHandler);
server.listen(port)
