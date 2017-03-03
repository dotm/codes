(function insertionSort (array){
  for (let i = 1; i < array.length; i++){
    let key = array[i]
    let j = i-1
    while (j >= 0 && array[j] > key){
      array[j+1] = array[j]
      j--
    }
    array[j+1] = key
  }
  return array;
})([3,2,1,5,4,6,7,8,9])

// Insertion Sort
function insertionSort (array){

  // For all element in the array (except the first one at index zero)
  for (let unsortedElementIndex = 1; unsortedElementIndex < array.length; unsortedElementIndex++){
    let unsortedElement = array[unsortedElementIndex];

    // Compare it with all the sorted element in right-to-left order (biggest-to-smallest / descending)
    // starting from the element just at the left of current unsorted element
    for(let sortedElementIndex = unsortedElementIndex - 1; sortedElementIndex >= 0; sortedElementIndex--){
      let sortedElement = array[sortedElementIndex];

      // If it's less than the compared element,
      if(unsortedElement < sortedElement){
        // Swap both element at the original array and continue comparing
        array[unsortedElementIndex] = sortedElement;
        array[sortedElementIndex] = unsortedElement;
      }
      // Else if it's greater than or equal to the compared element,
      else if(unsortedElement >= sortedElement){
        // Leave the element as is and stop comparing
        break;
      }
    }
  }

  // Return the result of insertion sort
  return array;
}
