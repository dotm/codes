//1.Multiples of 3 and 5
//Find the sum of all the multiples of 3 or 5 below 1000. -> 233168
(function(){
  _.mixin({
    sum: function(list) {
      return _.reduce(list, function(memo, num){ return memo + num; })
    }
  });
  
  var list = _.range(1000)
  var filteredList = _.filter(list, function(num){return num%3 === 0 || num%5 === 0;})
  return _.sum(filteredList)
})()
  
(function(){
  var total = 0
  for (var i=0; i<1000; i++){
    if ( i%3===0 || i%5===0 ){
      total+=i
    }
  }
  return total
})()
