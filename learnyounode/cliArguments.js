let input = process.argv
let number = input.slice(2)
number = number.map((x)=>Number(x))
let result = number.reduce((x,y)=>(x+y))
console.log(result)


//official solution
var result = 0

for (var i = 2; i < process.argv.length; i++) {
	result += Number(process.argv[i])
}

console.log(result)
