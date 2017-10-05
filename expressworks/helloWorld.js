const express = require('express')
let port = process.argv[2]
let app = express()

function requestHandler (req,res){
    res.end('Hello World!')
}

app.get('/home',requestHandler)
app.listen(port)