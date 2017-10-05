let mongo = require('mongodb').MongoClient
let url = 'mongodb://localhost:27017/learnyoumongo'
let ageArg = parseInt(process.argv[2])
function connHandler(err,db){
    if (err) throw err
    let parrots = db.collection('parrots')
    parrots.count(
        {age: {$gt: ageArg}},
        function(err,count){
            if (err) throw err
            console.log(count)
            db.close()
        }
    )
}
mongo.connect(url, connHandler)