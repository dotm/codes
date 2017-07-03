function Heap(array){
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
  // start doing Float-down from the top non-leave element ( floor(A.length/2) ) to the bottom ( A[i] )
  for (var i = Math.floor( this.heapSize / 2 ); i>0; i--){
    this.floatDownElementOfIndex(i)
  }
}
MaxHeap.prototype = Object.create(Heap.prototype);
MaxHeap.prototype.constructor = MaxHeap;

// Float-up method: float up an element to its correct position in the heap
MaxHeap.prototype.floatUpElementOfIndex = function floatUpElementOfIndex(currentIndex){
  var currentElement = this.heap[ currentIndex ]
  
  while(true){
    var parentIndex = this.getParentIndexOf( currentIndex )
    var parentElement = this.heap[ parentIndex ]
    
    if(currentElement > parentElement && currentIndex > 1){
      this.switchNodesOfIndex(currentIndex, parentIndex)
      var currentIndex = parentIndex
      var currentElement = this.heap[ currentIndex ]
    }else{
      break;
    }
  }
}

// Float-down method: float down an element to its correct position in the heap
MaxHeap.prototype.floatDownElementOfIndex = function floatDownElementOfIndex(currentIndex){
  var currentElement = this.heap[ currentIndex ]
  var leftChildIndex = this.getLeftChildIndexOf( currentIndex )
  var leftChild = this.heap[ leftChildIndex ]
  var rightChildIndex = this.getRightChildIndexOf( currentIndex )
  var rightChild = this.heap[ rightChildIndex ]
  
  var largest = currentIndex
  if( leftChildIndex <= this.heapSize && leftChild > currentElement ){
    largest = leftChildIndex
  }
  if( rightChildIndex <= this.heapSize && rightChild > currentElement ){
    largest = rightChildIndex
  }
  
  if( largest !== currentIndex ){
    this.switchNodesOfIndex(currentIndex, largest)
    currentIndex = largest
    floatDownElementOfIndex.call(this, currentIndex)
  }
}

//------------------------------------------------
// Max-heap sorting method
var heapSort = function(array){
  var maxHeap = new MaxHeap(array)
  
  while(maxHeap.heapSize){
  
    // Remove the null first element
    maxHeap.heap.shift()
    // Pick the root of the heap, push the whole heap array to the left, put the ex-root at the end of the heap
    maxHeap.heap.push( maxHeap.heap.shift() )
    // Restore the null
    maxHeap.heap.unshift(null)
    
    maxHeap.heapSize--    
    maxHeap.floatDownElementOfIndex(1)
  }
  
  // Delete the null first element
  maxHeap.heap.shift()
  // Reverse the descending array and return the ascending sorted result
  return maxHeap.heap.reverse()
}

//-------------------------------------------------
// Max-priority queue
// is a priority queue implemented from a Max-heap
function MaxPriorityQueue(array){
  MaxHeap.call(this, array)
}
MaxPriorityQueue.prototype = Object.create(MaxHeap.prototype);
MaxPriorityQueue.prototype.constructor = MaxPriorityQueue;

// Insert(S,x) inserts the element x into the set S, which is equivalent to the operation S=S∪{x}
MaxPriorityQueue.prototype.insert = function(element){
  this.heapSize++
  this.heap[ this.heapSize ] = element
  this.floatUpElementOfIndex( this.heapSize )
}

// Maximum(S) returns the element of S with the largest key.
MaxPriorityQueue.prototype.getMax = function(){
  return this.heap[1]
}

// Extract-max(S) removes and returns the element of S with the largest key.
MaxPriorityQueue.prototype.extractMax = function(){
  if (this.heapSize < 1){throw Error("Heap underflow")}
  var max = this.getMax()
  this.heap[1] = this.heap.pop()
  this.heapSize--
  this.floatDownElementOfIndex(1)
  return max
}

// Increase-key(S,x,k) increases the value of element x’s key to the new value k,
MaxPriorityQueue.prototype.increaseKey = function(index, newValue){
  if(newValue < this.heap[index]){
    throw Error("New key value is less than current key value");
    return;
  }
  this.heap[index] = newValue
  this.floatUpElementOfIndex(index)
}