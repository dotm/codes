let fs = require('fs')
let str = fs.readFileSync(process.argv[2]).toString()
let arr = str.split("\n")
let totalNewLine = arr.length - 1
console.log(totalNewLine)
