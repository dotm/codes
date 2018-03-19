#Node
class Node
  #Linked Lists are made of Nodes
  def initialize (value, next_node, prev_node=nil)
  #The Nodes have
    #a value as the key of that node
    @value = value
    #a next pointer to the next Node
    @next = next_node
    #a prev pointer to the previous Node (in case of Doubly Linked List)
    @prev = prev_node
    #any kind of satellite data (Object, Database Entry, etc.)
      #You can put the satellite data directly in the "value"
  end
  #To initialize the Node, you can use:
    #regular multiple arguments init(value,next,prev=NULL)
    #an object argument: init({value: ..., next:..., prev:...})
  
  #GET-VALUE operation
  def get_value
    return @value
  end
  
  #GET-NEXT-NODE operation
  def get_next_node
    return @next
  end
  
  #GET-PREV-NODE operation
  def get_prev_node
    #this will return NULL with Singly Linked List's Node
    return @prev
  end
  
  #SET-VALUE operation
  def set_value new_value
    @value = new_value
  end
  
  #SET-NEXT-NODE operation
  def set_next_node new_node
    @next = new_node
  end
  
  #SET-PREV-NODE operation
  def set_prev_node new_node
    @prev = new_node
  end
  
end

#Doubly Linked List (Non-Circular)
class D
  #You can implement Doubly Linked List using a series of Nodes with no prev pointers
  def initialize
    #L.head points to the first node or to NULL (if the list is empty)
    @head = nil
    #OPTIONAL: L.tail points to the last node or to NULL if the list is empty (tail will only be used for OPTIONAL OPERATIONS)
    @tail = nil
  end
  
  #LIST-INSERT(value) splices node onto the front of the linked list
  def insert value
    current_head = @head
    #create a new node with:
      #"value" that come from LIST-INSERT argument
      #"next" that point to the node that is currently at the head
      #"prev" that is NULL since it will be spliced onto the front of the list
    new_node = Node.new value, current_head, nil
    #if the list is not empty (L.head != NULL)(there exist at least one node in the list)
    if current_head != nil
      #point the old head node prev pointer to the new node
      current_head.set_prev_node new_node
    #OPTIONAL: if the list is empty, set tail to the the first node
    else
      @tail = new_node
    end
    #point L.head to the new node
    @head = new_node
    #You can return a pointer to the new node so you can access it quickly (e.g. for reading, updating or deleting)
    return new_node
    #You can return the list so that you can chain methods
    return self
  end
  
  #LIST-SEARCH(value) finds the first node by key/value in the linked list L using a simple linear search
  def search key
    #start searching from the head (if the head is NULL, get out of the function and return NULL)
    node = @head
    #while there's still any unsearched node in the list (you haven't reach the end of the list) and the wanted node hasn't been found
    while (node != nil) && (node.get_value != key)
      #search the wanted node linearly using the next pointer
      node = node.get_next_node
      #You MUST keep the order of the logical checking or you'll get an error for trying to check the key of NULL
    end
    #return a pointer to the wanted node (if no node with the key appears in the list, this will return NULL)
    return node
  end
    
  #LIST-DELETE-BY-NODE(node) removes a node from the linked list by the pointer to that node
  def delete_node this_node
    prev_node = this_node.get_prev_node
    next_node = this_node.get_next_node
    #if the deleted node is currently at the head
    if @head == this_node
      #set the head to the next node of this node
      @head = next_node
      #the head will be set to NULL if there's no node after this node (if this node is the only node in the list)
    end
    #if there's a node before this deleted node
    if prev_node != nil
      #point the next pointer of the previous node (of the deleted node) to the next node (of the deleted node)
      prev_node.set_next_node next_node
    end
    #if there's a node after this deleted node
    if next_node != nil
      #point the prev pointer of the next node (of the deleted node) to the previous node (of the deleted node)
      next_node.set_prev_node prev_node
    end
    #OPTIONAL: if the deleted node is at the tail
    if @tail == this_node
      #update the tail by pointing it to the previous node (of the deleted node)
      #this will return NULL if the deleted node is the only node in the list
      @tail = prev_node
    end
    #You can return the list so that you can chain methods
    return self
  end
  
  #LIST-DELETE-BY-VALUE(value) removes a node from the linked list by the value to that node
  def delete_value value
    #find the pointer to the wanted node using LIST-SEARCH(value)
    #then delete that node with LIST-DELETE-BY-NODE(node)
    delete_node(self.search(value))
  end
  
  #OPTIONAL OPERATIONS
  #LIST-EMPTY operation
  def empty?
    @head==nil ? true : false
  end
  #LIST-GET-HEAD-DATA operation
  def get_head_data
    return @head.get_value
  end
  #LIST-DELETE-HEAD remove the node at the head of the list
  def delete_head
    delete_node @head
  end
  #LIST-GET-TAIL-DATA operation (require a tail variable that you must keep track)
  def get_tail_data
    return @tail.get_value
  end
  #LIST-DELETE-TAIL operation (require a tail variable that you must keep track)
  def delete_tail
    delete_node @tail
  end
end

#Queue (implemented using a doubly linked list)
class Q
  def initialize
    @queue = D.new
  end
  
  #QUEUE-EMPTY operation
  def empty?
    #invoke LIST-EMPTY operation
    @queue.empty?
  end
  
  #INSERT operation (ENQUEUE)
  def enqueue element
    #add element to the back ("tail") of the queue (head of linked list)
    @queue.insert element
    #You can return queue so you can chain operation
    return self
  end
  
  #DELETE operation (DEQUEUE)
  def dequeue
    #if queue is empty, return QUEUE-UNDERFLOW error
    if empty? then return "QUEUE-UNDERFLOW" end
    #store the element at the front of the queue (tail of linked list) in a temporary variable
    temp = @queue.get_tail_data
    #remove the element from the queue
    @queue.delete_tail
    #return the temporary stored element
    return temp
  end
end