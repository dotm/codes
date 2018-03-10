Number.prototype.isDivisibleBy = function(number){
  var thisNumber = this.valueOf()
  
  if(thisNumber % number === 0){
    return true
  }else{
    return false
  }
}

Number.prototype.times = function(callback){
  var times = this.valueOf()
  
  for(var i=0; i < times; i++){
    var index = i
    callback(index);
  }
}

function printAppropriateString(number){
  var appropriateString;
  
  if(number.isDivisibleBy(3) && number.isDivisibleBy(5)){
    appropriateString = "FizzBuzz"
  }else if(number.isDivisibleBy(3)){
    appropriateString = "Fizz"
  }else if(number.isDivisibleBy(5)){
    appropriateString = "Buzz"
  }
  
  console.log(appropriateString)
}

function fizzBuzz(){
  var x = 100
  x.times(printAppropriateString)
}

fizzBuzz()