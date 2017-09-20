const net = require('net')
let port = Number(process.argv[2])

function zeroFill(n){
  return n<10 ? '0'+n : n
}

function now () {
  let d = new Date()
  return d.getFullYear() + '-' +
    zeroFill(d.getMonth() + 1) + '-' +
    zeroFill(d.getDate()) + ' ' +
    zeroFill(d.getHours()) + ':' +
    zeroFill(d.getMinutes())
}

let server = net.createServer((socket)=>{
	socket.end(now()+'\n')
})

server.listen(port)
