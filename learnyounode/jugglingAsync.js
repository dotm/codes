const http = require('http')
let URLs = [process.argv[2],process.argv[3],process.argv[4]]
let results = ['','','']
let count = 0

function printResults(results){
  for(let i=0; i<results.length; i++){
    console.log(results[i])
  }
}

URLs.forEach((url)=>{
  http.get(url, (res)=>{
    res.setEncoding('utf8');
    res.on('data',(data)=>{
      if(url === URLs[0]){
        results[0] += data
      }else if(url === URLs[1]){
        results[1] += data
      }else if(url === URLs[2]){
        results[2] += data
      }else{
        console.error("WTF!")
      }
    })

    res.on('end',()=>{
      count++;
      if(count >= 3){
        printResults(results);
      }
    })
  })
})
