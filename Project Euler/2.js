//2.Even Fibonacci numbers
//By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
//-> 4613732
(function(){
  _.mixin({
    sum: function(list) {
      return _.reduce(list, function(memo, num){ return memo + num; })
    }
  });
  
  var list = [1,2]
  while (true){
    var lastNumber = _.sum(_.last(list,2))
    if (lastNumber <= 4000000){
      list[list.length]=lastNumber
    }else{
      break
    }
  }
  var filteredList = _.filter(list, function(num){return num%2 === 0})
  return _.sum(filteredList)
})()

(function(){
  var total = 0
  var list = [1,2]
  while (true){
    var lastNumber = list[list.length-1] + list[list.length-2]
    if (lastNumber <= 4000000){
      list.push(lastNumber)
    }else{
      break
    }
  }
  for (var i = 0; i < list.length; i++){ 
    if (list[i]%2 === 0){
      total += list[i]
    }
  };
  return total
})()
