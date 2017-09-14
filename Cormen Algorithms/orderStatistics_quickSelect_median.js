// The i th order statistic of a set of n elements is the i th smallest element.
// A set is a collection of unique elements

Array.prototype.rselect = function (i){
  randSelect(this, 0, this.length - 1, i)
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
// PARTITION(originalArray, startingSubarrayIndex, endingSubarrayIndex) for use in RANDOMIZED-SELECT
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
// RANDOMIZED-PARTITION(originalArray, startingSubarrayIndex, endingSubarrayIndex) for use in RANDOMIZED-SELECT
function randPartition (array, start, end){
  // pick a randomIndex from inside the array (from startingSubarrayIndex to endingSubarrayIndex)
  randIndex = getRandomInt(start,end)
  // swap the element on endingSubarrayIndex with the randomIndex (since the endingSubarrayIndex will be used as pivot in PARTITION operation)
  array.swap(end,randIndex)
  // PARTITION the originalArray as usual and return the result of that PARTITION
  return partition(array, start, end)
}
// RANDOMIZED-SELECT(originalArray, startingSubarrayIndex, endingSubarrayIndex, i-th element) a.k.a QUICK-SELECT
function randSelect(array, start, end, i){
  // if there's only one element in the subarray (base case), just return it
  if(start = end) return array[start]
  // partition the array using RANDOMIZED-PARTITION and store the resulting partitionIndex
  var partitionIndex = randPartition(array, start, end)
  var k = (partitionIndex - start + 1)
  // if the pivot value is the answer (i == (partitionIndex - startingSubarrayIndex + 1)), return the pivot value
  if (i === k){
    return array[partitionIndex]
  // else if the i-th element is in the left (smaller) subarray
  }else if (i < k){
    // do RANDOMIZED-SELECT on the left subarray
    return randSelect(array, start, partitionIndex-1, i)
  // else if the i-th element is in the right (larger) subarray
  }else{
    // do RANDOMIZED-SELECT on the right subarray
    return randSelect(array, partitionIndex+1, end, i-k)
  }
}

set = [1,0,4,2,3,5]
set.rselect(0)