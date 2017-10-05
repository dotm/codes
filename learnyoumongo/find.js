let mongo = require('mongodb').MongoClient
let url = 'mongodb://localhost:27017/learnyoumongo'
function mongoCallback (err,db){
    if (err) throw err
    let parrots = db.collection('parrots')
    parrots
        .find({age: {$gt: parseInt(process.argv[2])}})
        .toArray(function(err, docs) {
            if (err) throw err
            console.log(docs)
            db.close()
        })
}
mongo.connect(url,mongoCallback)
