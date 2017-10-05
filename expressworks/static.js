const express = require('express')
let port = process.argv[2]
let app = express()
let htmlFile = process.argv[3]
app.use(express.static(htmlFile))
app.listen(port)