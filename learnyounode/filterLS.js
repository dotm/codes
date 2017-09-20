let fs = require('fs')
let dir = process.argv[2]
let ext = process.argv[3]
fs.readdir(dir,(err,list)=>{
  list = list.filter((f)=>{return f.match("."+ext)})
  list.map((e)=>{console.log(e)})
})

//official solution
var fs = require('fs')
var path = require('path')

var folder = process.argv[2]
var ext = '.' + process.argv[3]

fs.readdir(folder, function (err, files) {
  if (err) return console.error(err)
  files.forEach(function (file) {
    if (path.extname(file) === ext) {
      console.log(file)
    }
  })
})
