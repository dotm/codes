// Check if array is sorted (by ascending element order)
Array.prototype.checkIfSorted = function(){

  // for all elements in array except the final element
  for (var i = 0; i < this.length-1; i++){
    // if the next element is smaller than this element, then array is not sorted
    if (this[i+1] < this[i]) {return false;}
  }
  // if all elements is smaller then the next element, then the array is sorted
  return true;
}