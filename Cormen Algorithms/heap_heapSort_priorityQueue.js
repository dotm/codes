function Heap(array){
  // the heap is private
  this.heap = array;
  // Assumption: heap's first element is on index number 1 (not zero-indexed)
  if (this.heap[0]){
    this.heap.unshift(null);
  }
  // heapSize exclude the null first element
  this.heapSize = this.heap.length - 1;
}

Heap.prototype.getParentIndexOf = function (currentIndex){
  return Math.floor( currentIndex / 2 )
}

Heap.prototype.getLeftChildIndexOf = function (currentIndex){
  return currentIndex * 2
}
Heap.prototype.getRightChildIndexOf = function (currentIndex){
  return (currentIndex * 2) + 1
}

Heap.prototype.switchNodesOfIndex = function (index1, index2){
  var temp = this.heap[index1]
  this.heap[index1] = this.heap[index2]
  this.heap[index2] = temp
}


//---------------------------------------------
// MaxHeap is a Heap where a node is always greater than or equal to than its children node
function MaxHeap(array){
  Heap.call(this, array);
  
  // Build-max-heap method: produces a max-heap from an unordered input array
  // The elements in the subarray A[(floor(n/2)+1) .. n] are all leaves of the tree, and so
  // start doing Max-heapify from the top non-leave element ( floor(A.length/2) ) to the bottom ( A[i] )
  for (var i = Math.floor( this.heapSize / 2 ); i>0; i--){
    this.maxHeapifyElementOfIndex(i)
  }
}
MaxHeap.prototype = Object.create(Heap.prototype);
MaxHeap.prototype.constructor = MaxHeap;

// Max-heapify method used to maintain the max-heap property ( A[PARENT(i)] >= A[i] )
MaxHeap.prototype.maxHeapifyElementOfIndex = function maxHeapifyElementOfIndex(parentIndex){
  var parentElement = this.heap[ parentIndex ]
  
  var leftChildIndex = this.getLeftChildIndexOf( parentIndex )
  var rightChildIndex = this.getRightChildIndexOf( parentIndex )
  
  // If left children is within heapSize (in the heap) and is bigger than its parent
  if( leftChildIndex <= this.heapSize ){
    var leftChild = this.heap[ leftChildIndex ]
    if( leftChild > parentElement ){
      // switch both node
      this.switchNodesOfIndex(parentIndex, leftChildIndex)
      // do this method again to the switched smaller element until max-heap property is satisfied
      maxHeapifyElementOfIndex.call( this, leftChildIndex )
    }
  }
  // If right children is within heapSize (in the heap) and is bigger than its parent
  else if( rightChildIndex <= this.heapSize ){
    var rightChild = this.heap[ rightChildIndex ]
    if ( rightChild > parentElement ){
      // switch both node
      this.switchNodesOfIndex(parentIndex, rightChildIndex)
      // do this method again to the switched smaller element until max-heap property is satisfied
      maxHeapifyElementOfIndex.call( this, rightChildIndex )
    }
  }
}

// Max-heap sorting method
var heapSort = function(array){
  // Build-max-heap of the array
  var maxHeap = new MaxHeap(array)
  
  // While heapSize is not zero
  while(maxHeap.heapSize){
  
    // Remove the null first element
    maxHeap.heap.shift()
    // Pick the root of the heap, push the whole heap array to the left, put the ex-root at the end of the heap
    maxHeap.heap.push( maxHeap.heap.shift() )
    // Restore the null
    maxHeap.heap.unshift(null)
    
    // Decrease the heap size by one
    maxHeap.heapSize--
    
    // Call Max-heapify on the heap to maintain the max-heap property
    maxHeap.maxHeapifyElementOfIndex(1)
  }
  
  // Delete the null first element
  maxHeap.heap.shift()
  // Reverse the descending array and return the ascending sorted result
  return maxHeap.heap.reverse()
}

//-------------------------------------------------
