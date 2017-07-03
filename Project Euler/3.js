//3.Largest prime factor
//What is the largest prime factor of the number 600851475143?  -> 6857
//If n is a composite integer, then n has a prime divisor less than or equal to sqrt(n)
(function(){
  _.mixin({
    isPrime: function(num) {
      var SQRT = parseInt(Math.sqrt(num))
      if(num <= 1){return false}
      for(var i = SQRT; i >= 2; i--){
        if (num%i === 0) {return false}
      }
      return true
    }
  });
  
  var num = 30
  var SQRT = parseInt(Math.sqrt(num))
  for(var i = SQRT; i >= 2; i--){
    if(num%i === 0 && _(i).isPrime()){return i}
  }  
})()

(function(){
  function isPrime(num){
    var SQRT = parseInt(Math.sqrt(num))
    if(num <= 1){return false}
    for(var i = SQRT; i >= 2; i--){
      if (num%i === 0) {return false}
    }
    return true
  }
  
  var num = 30
  var SQRT = parseInt(Math.sqrt(num))
  for(var i = SQRT; i >= 2; i--){
    if(num%i === 0 && isPrime(i)){return i}
  }  
})()
