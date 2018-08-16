//Primality test
function isPrime (num) {
  if(num <= 1){return false}
  
  //If n is a composite (non-prime) integer, then n has a prime divisor less than or equal to square_root(n)
  var upper_limit = Math.floor(Math.sqrt(num))
  
  for(var i = upper_limit; i >= 2; i--){
    if (num%i === 0) {return false}
  }
  return true
}