const express = require('express')
let port = process.argv[2]
let app = express()
let pugFile = process.argv[3]

app.set("view engine", 'pug')
function requestHandler (req,res){
    res.render(pugFile, {date: new Date().toDateString()}) 
}

app.get('/home',requestHandler)
app.listen(port)