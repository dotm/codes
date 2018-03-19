#Queue (implemented using a fixed sized array)
class Q
  def initialize queue_capacity
    @queue = []
    #Use a "queue_capacity" variable to limit the length of the fixed sized array
    @queue_capacity = queue_capacity
    #Use a "total" variable to keep the total number of element in the queue
    @total = 0
    #Use a "head" variable to point to the front index of the queue where the first element is in
    @head = 0
    #Use a "tail" variable to point to the back index of the queue where the latest element will be inserted
    @tail = 0
  end
  
  #QUEUE-EMPTY operation
  def empty?
    #if total <= 0, then the queue is empty
    @total <= 0 ? true : false
  end
  
  #QUEUE-FULL operation
  def full?
    #if "total" >= "queue_capacity" then queue is full
    (@total >= @queue_capacity) ? true : false
  end
  
  #INSERT operation (ENQUEUE)
  def enqueue element
    #if queue is full, return QUEUE-OVERFLOW error
    if full? then return "QUEUE-OVERFLOW" end
    #add element to the back ("tail") of the queue
    @queue[@tail] = element
    #increment "tail" with mod operator (to make sure it loop back when we get to the end of array)
      #tail = (tail + 1) % queue_capacity
    @tail = (@tail + 1) % @queue_capacity
    #increment "total"
    @total += 1
    #You can return queue so you can chain operation
    return self
  end
  
  #DELETE operation (DEQUEUE)
  def dequeue
    #if queue is empty, return QUEUE-UNDERFLOW error
    if empty? then return "QUEUE-UNDERFLOW" end
    #store the element at the front of the queue in a temporary variable
    temp = @queue[@head]
    #OPTIONAL: set the element at the front of the queue to NULL
    @queue[@head] = nil
    #move the "head" to the next element on the queue (increment "head" with mod operator to make sure it loop back when we get to the end of the array)
      #head = (head + 1) % queue_capacity
    @head = (@head + 1) % @queue_capacity
    #decrement "total"
    @total -= 1
    #return the temporary stored element
    return temp
  end
end