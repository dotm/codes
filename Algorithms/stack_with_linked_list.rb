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
    #L.head points to the first Node or to NULL (if the list is empty)
    @head = nil
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
end

class Stack
  #You can implement a stack internally using a doubly linked list
  def initialize
    @stack = D.new
  end
  
  #STACK-EMPTY operation
  def empty?
    #invoke LIST-EMPTY operation
    @stack.empty? ? true : false
  end
  
  #INSERT operation (PUSH)
  def push element
    #add element to the top of the stack (head of the linked list)
    @stack.insert element
    #You can return the stack so that you can chain methods
    return self
  end
  
  #DELETE operation (POP)
  def pop
    #if the stack is empty, return a STACK-UNDERFLOW error
    if empty? then return "STACK-UNDERFLOW" end
    #invoke LIST-GET-HEAD-DATA and store the result (the top element) on a temporary variable
    temp = @stack.get_head_data
    #invoke LIST-DELETE-HEAD to delete the top element
    @stack.delete_head
    #return the (temporarily) stored element
    return temp
  end
end