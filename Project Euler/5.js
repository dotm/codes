// 5.Smallest multiple
// What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
// -> 232792560

(function(){
  function isPrime(num){
    var SQRT = parseInt(Math.sqrt(num))
    if(num <= 1){return false}
    for(var i = SQRT; i >= 2; i--){
      if (num%i === 0) {return false}
    }
    return true
  }
  function isNotPrime(num){ return !isPrime(num) }
  function splitFactor(num){
    var SQRT = parseInt(Math.sqrt(num))
    if(num <= 1){return}
    for(var i = SQRT; i >= 2; i--){
      if (num%i === 0) {return [i, num/i]}
    }
    return [num]
  }
  function primeFactorize(x){
    if(!(x instanceof Array)) { var x = [x] }
    var nonPrime = _(x).find(isNotPrime);
    while (nonPrime) {
      x = _.flatten( _(x).map(splitFactor) )
      nonPrime = _(x).find(isNotPrime);
    }
    return x.sort(function(a,b){return a-b})
  }
  function multiply(prev,curr) {return prev * curr}
  
  function lcm(array) {
    if ( _.find(array, function(x){return x < 2}) ){
      console.log("Exclude number less than 2!")
      return
    }
    
    var y = _.map(array, primeFactorize)
    var primeFactors = _( _.flatten(y) ).uniq()
    var result = []
    
    _.each(primeFactors, function(i){
      var temp = []
      _.each(y, function(j){
        var filteredByPrime = j.filter(function(x){return x===i})
        if(filteredByPrime.length){
          temp.push( filteredByPrime.reduce(multiply) )
        }
      })
      result.push( _.max(temp) )
    })
    
    return result.reduce(multiply)
  } 
  
  lcm([2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])
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
  function splitFactor(num){
    var SQRT = parseInt(Math.sqrt(num))
    if(num <= 1){return}
    for(var i = SQRT; i >= 2; i--){
      if (num%i === 0) {return [i, num/i]}
    }
    return [num]
  }
  function primeFactorize(x){
    if(!(x instanceof Array)) { var x = [x] }
    
    for (var i = 0; i < x.length; i++){ 
      if( !isPrime(x[i]) ){
        var nonPrime = x.splice(i,1)
        x = x.concat( splitFactor(nonPrime) )
        i=-1
      }
    }
    return x.sort(function(a,b){return a-b})
  }
  function primeFactorizeUniq(num){
    var SQRT = parseInt(Math.sqrt(num))
    var factors = []
    if(num <= 1){return false}
    for(var i = SQRT; i >= 2; i--){
      if (num%i === 0 && isPrime(i)) {factors.push(i)}
    }
    return factors.sort(function(a,b){return a-b})
  }
  
  function lcm(array) {
    var primeFactors = []
    var y = []
    var result = []
    for (var i = 0; i < array.length; i++){
      var temp = []
      if(array[i]<2){console.log("Exclude number less than 2!"); return}
      temp = primeFactorize(array[i])
      for (var j = 0; j < temp.length; j++){
        if(primeFactors.indexOf(temp[j]) === -1){
          primeFactors.push(temp[j])
        }
      }
      y.push(temp)
    }
    
    for (var i = 0; i < primeFactors.length; i++){
      var temp = []
      for (var j = 0; j < y.length; j++){
        var filteredByPrime = y[j].filter(function(x){return x===primeFactors[i]})
        if(filteredByPrime.length){
          temp.push( filteredByPrime.reduce(function(prev,curr){return prev * curr}) )
        }
      }
      result.push( temp.sort(function(a,b){return a-b})[temp.length-1] )
    }
    return result.reduce(function(prev,curr){return prev * curr})
  } 
  
  lcm([2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])
})()
