(function insertionSort (array){
  for (var i = 1; i < array.length; i++){
    var key = array[i]
    var j = i-1
    while (j >= 0 && array[j] > key){
      array[j+1] = array[j]
      j--
    }
    array[j+1] = key
  }
  return array;
})([3,2,1,5,4,6,7,8,9])