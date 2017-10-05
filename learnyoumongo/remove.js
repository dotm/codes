let mongo = require('mongodb').MongoClient
let dbName = process.argv[2]
let collectionName = process.argv[3]
let idArg = process.argv[4]
let url = 'mongodb://localhost:27017/' + dbName
function connCB(err,db){
    if (err) throw err
    let collection = db.collection(collectionName)
    collection.remove(
        {_id: idArg},
        function(err){
            if (err) throw err
            db.close()
        }
    )
}

mongo.connect(url,connCB)