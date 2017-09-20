const http = require('http')
const url = process.argv[2]

let responseHandler = function(res){
  res.setEncoding('utf8');
  let tempResult = []
  res.on('data', (data)=>{tempResult.push(data)})
  res.on('error', console.error)
  res.on('end', function(){
    let result = tempResult.join('')
    console.log(result.length)
    console.log(result)
  })
}

http.get(url, responseHandler)
