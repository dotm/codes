// The i th order statistic of a set of n elements is the i th smallest element.
// A set is a collection of unique elements

//MINIMUM(set) find the minimum element of a set
function minimum(set){
  // set a "min" variable as the storage of currently minimum element
  // set the first element of the set to "min"
  var min = set[0]
  // iterate through the set
  for(var i=0; i<set.length; i++){
    // if the currently checked element is smaller than "min"
    if(set[i] < min){
      // replace "min" with the currently checked element
      min = set[i]
    }
  }
  // return "min"
  return min
}

//MAXIMUM(set) find the maximum element of a set
function maximum(set){
  // set a "max" variable as the storage of currently maximum element
  // set the first element of the set to "max"
  var max = set[0]
  // iterate through the set
  for(var i=0; i<set.length; i++){
    // if the currently checked element is bigger than "max"
    if(set[i] > max){
      // replace "max" with the currently checked element
      max = set[i]
    }
  }
  // return "max"
  return max
}