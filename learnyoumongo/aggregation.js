let mongo = require('mongodb').MongoClient
let url = 'mongodb://localhost:27017/learnyoumongo'
let sizeArg = process.argv[2]
function connectionHandler(err,db){
    if (err) throw err
    let prices = db.collection('prices')
    prices
        .aggregate([
            {$match: {size: sizeArg}},
            {$group: {
                _id: 'average',
                average: {$avg: '$price'}
            }}
        ])
        .toArray(function(err,result){
            if (err) throw err
            if (!result.length) {
                throw new Error('No results found')
            }
            let average = Number(result[0].average)
            console.log(average.toFixed(2))
            db.close()
        })
}

mongo.connect(url, connectionHandler)