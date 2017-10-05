let mongo = require('mongodb').MongoClient
let url = 'mongodb://localhost:27017/learnyoumongo'
let ageArg = parseInt(process.argv[2])
function connectionHandler(err,db){
    if (err) throw err
    let parrots = db.collection('parrots')
    parrots
        .find(
            {age: {$gt: ageArg}},
            {
                name: 1
                , age: 1
                , _id: 0
            }
        )
        .toArray(function(err,docs){
            if (err) throw err
            console.log(docs)
            db.close()
        })
}

mongo.connect(url, connectionHandler)