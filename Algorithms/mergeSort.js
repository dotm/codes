Array.prototype.isEmpty = function(){return this.length === 0;};
  
// Merge (for merge sort)
// Take 2 array as input
function merge (firstArray, secondArray) {
  var outputArray = [];
  
  // While both input arrays are not empty
  while( !firstArray.isEmpty() && !secondArray.isEmpty() ){
  
    // Take the smallest element from both input array and compare them
    // Remove the smaller element and put it into the top of the output array
    if ( firstArray[0] <= secondArray[0] ) {
      outputArray.push( firstArray.shift() );
    }else if ( firstArray[0] > secondArray[0] ) {
      outputArray.push( secondArray.shift() );
    }
  }
  
  // After one input array is empty, put the rest of the other input into the output array
  if( firstArray.isEmpty() ){
    outputArray = outputArray.concat( secondArray );
  }else if( secondArray.isEmpty() ){
    outputArray = outputArray.concat( firstArray );
  }
  
  // Return the merged result
  return outputArray;
}


// Merge Sort
function mergeSort(array){

  // If base case is achieved, just return it
  if(array.length === 1){return array;}
  
  // Divide the array evenly into 2 parts
  var midPoint = Math.floor( array.length/2 );
  var topArray = array.splice(midPoint);
  var bottomArray = array;
  
  // Call merge sort on both parts
  topArray = mergeSort(topArray);
  bottomArray = mergeSort(bottomArray);
  
  // Merge the results of the merge sort executed on both parts
  var sortedArray = merge(topArray, bottomArray);
  
  // Return the sorted result
  return sortedArray;
}

mergeSort([6,11,2,8,99,0,-1,0.1]);
// console.log();
