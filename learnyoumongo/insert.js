let mongo = require('mongodb').MongoClient
let url = 'mongodb://localhost:27017/learnyoumongo'
let firstName = process.argv[2]
let lastName = process.argv[3]
let doc = {
    firstName: firstName,
    lastName: lastName
}

function connCB(err,db){
    if (err) throw err
    let collection = db.collection('docs')
    collection.insert(doc, function(err, data){
        if (err) throw err
        console.log(JSON.stringify(doc))
        db.close()
    })
}

mongo.connect(url, connCB)