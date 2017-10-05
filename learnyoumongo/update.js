let mongo = require('mongodb').MongoClient
let dbName = process.argv[2]
let url = 'mongodb://localhost:27017/' + dbName
function connCB(err,db){
    if (err) throw err
    let collection = db.collection('users')
    collection.update(
        {username: 'tinatime'},
        {$set:{age: 40}},
        function(err){
            if (err) throw err
            db.close()
        }
    )
}

mongo.connect(url,connCB)