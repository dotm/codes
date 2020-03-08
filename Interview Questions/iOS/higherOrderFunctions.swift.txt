let users = [
    (name:"Dane", age:16, money:10.0),
    (name:"Don", age:26, money:70.0),
    (name:"Din", age:36, money:120.0),
]

var names = users.map({user in user.name})
//names == ["Dane", "Don", "Din"]

var users_above18 = users.filter({user in user.age > 18})
//users_above18 == [(name: "Don", age: 26, money: 70), (name: "Din", age: 36, money: 120)]

var totalMoney = users.reduce(0, {accumulator, user in accumulator + user.money })
//totalMoney == 200

[1,2,3,4].reduce(0,+)

[1,2,3,4].map(sqrt)

