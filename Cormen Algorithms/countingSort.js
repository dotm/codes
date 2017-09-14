// COUNTING-SORT(originalArray) will sort an array at O(n)
// but only if the elements inside the array has bounded range (minimum value is 0 and maximum value is an integer k)
function countingSort(originalArray, maxInt){
  // initialize a resultArray (that have the same length as originalArray) that will be used to hold the sorted output
  var resultArray = []
  // initialize a tempArray that will be used as a temporary working storage for the count total of each integer occurence (from 0 to k) in originalArray
  var tempArray = []
  // the tempArray will obviously have k index (from the maximum value) since it will store the count total of each integer from 0 to k
  for(var i = 0; i <= maxInt; i++){
    tempArray[i]=0
  }
  // for all elements inside originalArray (from the first index to last index)
  for(var j = 0; j < originalArray.length; j++){
    // increment the count on tempArray for each respective integer
    tempArray[originalArray[j]] += 1
    // each tempArray index now store the count of all integer in originalArray
  }
  // for all count in the tempArray except the first one: for i=1 to k (instead of: for i=0 to k)
  for(var i = 1; i <= maxInt; i++){
    // add the count total of the previous index to current index iteratively (we start from i=1 since i=0 doesn't have a previous index)
    tempArray[i] += tempArray[i-1]
    // each tempArray index now store the total number of elements that is less than or equal to the integer i in the originalArray
      // this information is used to place an element directly into its position in the output array
  }
  // for all elements inside originalArray (from the last index to first index)
  for(var j = originalArray.length - 1; j >= 0; j--){
    // put it in the correct position inside the resultArray
    currentElement = originalArray[j]
    positionOfCurrentElement = tempArray[currentElement] - 1
    resultArray[positionOfCurrentElement] = currentElement
    // decrement the count of the number that you just put inside the resultArray
    tempArray[currentElement] -= 1
  }
  // return the resultArray
  return resultArray
}

// This implementation of COUNTING-SORT is stable (you can use it for RADIX-SORT)