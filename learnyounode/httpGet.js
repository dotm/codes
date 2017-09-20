const http = require('http')
const URL = process.argv[2]

let responseHandler = function(res){
  res.setEncoding('utf8');
  res.on('data', console.log);
  res.on('error', console.error);
}

http
  .get(URL, responseHandler)
  .on('error', console.error)
