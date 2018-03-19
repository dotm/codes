Array.prototype.qsort = function (){
  randQuickSort(this, 0, this.length - 1)
  return this
}
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
// SWAP(firstIndex, secondIndex) to swap two elements of an array
Array.prototype.swap = function (firstIndex, secondIndex){
  // store the second element in a temporary variable
  var temp = this[secondIndex]
  // store the first element in the secondIndex
  this[secondIndex] = this[firstIndex]
  // store the second element from the temporary variable in the firstIndex
  this[firstIndex] = temp
  return this
}

// QUICK-SORT(originalArray, startingSubarrayIndex, endingSubarrayIndex)
function quickSort (array, start, end){
  // if startingSubarrayIndex < endingSubarrayIndex (if base case has not been achieved)
  if (start < end){
    // partition the array and store the resulting partitionIndex
    var partitionIndex = partition(array, start, end)
    // recursively invoke QUICK-SORT both from startingSubarrayIndex to (partitionIndex - 1)
    quickSort(array, start, partitionIndex-1)
    // and from (partitionIndex + 1) to endingSubarrayIndex
    quickSort(array, partitionIndex+1, end)
  }
}
// PARTITION(originalArray, startingSubarrayIndex, endingSubarrayIndex) for use in QUICK-SORT
function partition (array, start, end){
  // choose pivot
  var pivot = array[end]
  // "lastOfSmallerIndex" variable points to the last (most right) index of the subarray for elements that are smaller than or equal to pivot
    // "lastOfSmallerIndex" is initialized to (startingSubarrayIndex - 1) since at first the number of smaller element is 0
  var lastOfSmallerIndex = start - 1
  // loop through the originalArray from startingSubarrayIndex to (and including) endingSubarrayIndex - 1 (the pivot is in endingSubarrayIndex)
  for(var i = start; i <= end - 1; i++){
    // if the current checked element is less than or equal to pivot
    if(array[i] <= pivot){
      // increment the "lastOfSmallerIndex" index so that it points to an element not yet checked or an element greater than pivot (breaking the loop invariant)
      lastOfSmallerIndex++
      // swap the currently checked element with the element in the "lastOfSmallerIndex" (restoring the loop invariant)
      array.swap(i, lastOfSmallerIndex)
    }
  }
  // increment the "lastOfSmallerIndex" index so that it points to an element not yet checked or an element greater than pivot (breaking the loop invariant)
  lastOfSmallerIndex++
  // and swap the pivot element at endingSubarrayIndex with the element in the "lastOfSmallerIndex" (restoring the loop invariant)
  array.swap(end, lastOfSmallerIndex)
  // return lastOfSmallerIndex (which now points to the pivot) to be used for the next iteration of QUICK-SORT as the new partitionIndex
  return lastOfSmallerIndex
}

// RANDOMIZED-QUICK-SORT(originalArray, startingSubarrayIndex, endingSubarrayIndex)
function randQuickSort (array, start, end){
  // if startingSubarrayIndex < endingSubarrayIndex (if base case has not been achieved)
  if (start < end){
    // partition the array using RANDOMIZED-PARTITION and store the resulting partitionIndex
    var partitionIndex = randPartition(array, start, end)
    // recursively invoke RANDOMIZED-QUICK-SORT both from startingSubarrayIndex to (partitionIndex - 1)
    randQuickSort(array, start, partitionIndex-1)
    // and from (partitionIndex + 1) to endingSubarrayIndex
    randQuickSort(array, partitionIndex+1, end)
  }
}
// RANDOMIZED-PARTITION(originalArray, startingSubarrayIndex, endingSubarrayIndex) for use in RANDOMIZED-QUICK-SORT
function randPartition (array, start, end){
  // pick a randomIndex from inside the array (from startingSubarrayIndex to endingSubarrayIndex)
  randIndex = getRandomInt(start,end)
  // swap the element on endingSubarrayIndex with the randomIndex (since the endingSubarrayIndex will be used as pivot in PARTITION operation)
  array.swap(end,randIndex)
  // PARTITION the originalArray as usual and return the result of that PARTITION
  return partition(array, start, end)
}

[0,1,4,3,9].qsort()
