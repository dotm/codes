//4.Largest palindrome product
//Find the largest palindrome made from the product of two 3-digit numbers. ->  906609
(function(){
  _.mixin({
    isPalindrome: function(x) {
      if (typeof x === "number"){ x = x.toString() }
      var xReversed = x.split("").reverse().join("")
      return x === xReversed ? true : false
    }
  });

  var array = []
  var max = 0
  for(var i = 999; i > 0; i--){
    for(var j = 999; j > 0; j--){
      var number = i*j
      if ( _(number).isPalindrome() ) {
        array.push(number)
        break
      }
    }
  }
  return _.max(array)
})()

(function(){
  function isPalindrome(x){
    if (typeof x === "number"){ x = x.toString() }
    var xReversed = x.split("").reverse().join("")
    return x === xReversed ? true : false
  }

  var array = []
  var max = 0
  for(var i = 999; i > 0; i--){
    for(var j = 999; j > 0; j--){
      var number = i*j
      if (isPalindrome(number)) {
        array.push(number)
        break
      }
    }
  }
  for (var i = 0; i < array.length; i++){ 
    if (array[i] > max) {max = array[i]}
  };
  return max
})()

