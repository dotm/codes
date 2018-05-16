=begin
  To test this code:
    - install rspec
    - copy this code to a file (e.g. linkedList.rb)
    - run the following command: rspec linkedList.rb
=end

#Node
class Node
  #Linked Lists are made of Nodes
  def initialize (value, next_node=nil, prev_node=nil)
    unless next_node == nil or next_node.is_a? Node
      raise TypeError, "next_node only accept Node object as argument"
    end
    unless prev_node == nil or prev_node.is_a? Node
      raise TypeError, "prev_node only accept Node object as argument"
    end

    @value = value
    @next = next_node
    @prev = prev_node
  end

  def get_value
    return @value
  end
  
  def get_next_node
    return @next
  end
  
  def get_prev_node
    #this will return NULL with Singly Linked List's Node
    return @prev
  end
  
  def set_value new_value
    @value = new_value
  end
  
  def set_next_node new_node
    @next = new_node
  end
  
  def set_prev_node new_node
    @prev = new_node
  end
  
end

#Doubly Linked List (Non-Circular)
class LinkedList
  def initialize
    #L.head points to the first Node or to NULL (if the list is empty)
    @head = nil
  end
  
  #LIST-INSERT(value) splices node onto the front of the linked list
  def insert value
    current_head = @head
    new_node = Node.new value, current_head, nil

    if current_head != nil
      current_head.set_prev_node new_node
    end

    @head = new_node
    #return a pointer to the new node so you can access it quickly (e.g. for reading, updating or deleting)
    return new_node
  end
  
  #LIST-SEARCH(value) finds the first node by key/value in the linked list L using a simple linear search
  def search key
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
    unless this_node.is_a? Node
      raise TypeError, "delete_node only accept Node object as argument"
    end
    
    prev_node = this_node.get_prev_node
    next_node = this_node.get_next_node

    if @head == this_node
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

    return self
  end
  
  #LIST-DELETE-BY-VALUE(value) removes a node from the linked list by the value to that node
  def delete_value value
    begin
      delete_node(self.search(value))
    rescue NoMethodError, TypeError
      raise NoValueError
    end
  end
  
  def empty?
    @head==nil ? true : false
  end

  def get_head
    return @head
  end

  def delete_head
    delete_node @head
  end
end

class NoValueError < StandardError
  def initialize(msg="the value given can't be found")
    super
  end
end

describe Node do
  describe "initialize method" do
    
    it "raise ArgumentError when given 0 argument" do 
      expect { Node.new }.to raise_error(ArgumentError)
    end
    
    describe "second argument (pointer to next node)" do
      it "should only accept a Node object" do
        expect { Node.new(1,2) }.to raise_error(TypeError)
        expect { Node.new(1,@aNode) }.not_to raise_error
      end
    end
    
    describe "third argument (pointer to previous node, if any)" do
      it "should only accept a Node object" do
        expect { Node.new(1,@aNode,3) }.to raise_error(TypeError)
        expect { Node.new(1,@aNode,@aNode) }.to_not raise_error
      end
    end
  end
  
  describe "interface:" do
    before :each do
      @aNode = Node.new 1
      @bNode = Node.new 2, @aNode
      @cNode = Node.new 3, nil, @aNode
      @newNode = Node.new 4
    end
    
    specify "you should be able to get and set the value of a node" do
      expect( @aNode.get_value ).to eq(1)
      @aNode.set_value 2
      expect( @aNode.get_value ).to eq(2)
    end
    
    specify "you should be able to get and set the (pointer to the) next node" do
      expect( @bNode.get_next_node ).to eq(@aNode)
      @bNode.set_next_node @newNode
      expect( @bNode.get_next_node ).to eq(@newNode)
    end
    
    specify "you should be able to get and set the (pointer to the) previous node" do
      expect( @cNode.get_prev_node ).to eq(@aNode)
      @cNode.set_prev_node @newNode
      expect( @cNode.get_prev_node ).to eq(@newNode)
    end
  end
end

describe LinkedList do
  before :each do
    @aList = LinkedList.new
  end
  
  it "should be empty when first created" do
    expect(@aList).to be_empty
  end
  
  specify "you should be able to access the head of the list (for testing purpose only?)" do
    expect { @aList.get_head }.to_not raise_error
  end
  
  describe "insert method" do
    it "should splice a node onto the front of the linked list" do
      expect( @aList.get_head ).to be_nil
      @aList.insert 1
      expect( @aList.get_head ).to_not be_nil
    end
  end
  
  describe "search (by value/key) method" do
    it "should return nil if no element with the given key is found" do
      expect( @aList.search 1 ).to be_nil
    end
    
    it "should return the first node with the given key" do
      @aList.insert 1
      @aList.insert 1
      expect( @aList.search 1 ).to be_a(Node).and eq( @aList.get_head )
    end
  end
  
  context "delete node" do
    before :each do
      #insert from 3 to 1, so that the created linked list will be [1 -> 2 -> 3]
      @aList.insert 3
      @aList.insert 2
      @aList.insert 1
      
      @aNode = @aList.search 1
      @bNode = @aList.search 2
      @cNode = @aList.search 3
    end
    
    describe "by pointer to a node" do
      it "should only accept a Node object" do
        expect { @aList.delete_node nil }.to raise_error(TypeError)
        expect { @aList.delete_node 1 }.to raise_error(TypeError)
        expect { @aList.delete_node @bNode }.not_to raise_error
      end
      
      it "should perform the usual linked list delete operation (modifying pointers of the node previous and next to it)" do
        #expect LinkedList = @aNode -> @bNode -> @cNode
        expect( @aList.get_head ).to eq(@aNode)
        expect( @aList.get_head.get_next_node ).to eq(@bNode)
        expect( @aList.get_head.get_next_node.get_next_node ).to eq(@cNode)
        expect( @cNode.get_prev_node ).to eq(@bNode)
        expect( @bNode.get_prev_node ).to eq(@aNode)
        
        @aList.delete_node @bNode
        
        #expect LinkedList = @aNode -> @cNode
        expect( @aList.get_head ).to eq(@aNode)
        expect( @aList.get_head.get_next_node ).to_not eq(@bNode)
        expect( @aList.get_head.get_next_node ).to eq(@cNode)
        expect( @cNode.get_prev_node ).to_not eq(@bNode)
        expect( @cNode.get_prev_node ).to eq(@aNode)
      end
    end
    
    describe "by value" do
      it "should raise error if the value is not found in the linked list" do
        expect { @aList.delete_value 999 }.to raise_error(NoValueError)
      end
      
      it "should perform the usual linked list delete operation (modifying pointers of the node previous and next to it)" do
        #the same expectations as delete by pointer
        
        #expect LinkedList = @aNode -> @bNode -> @cNode
        expect( @aList.get_head ).to eq(@aNode)
        expect( @aList.get_head.get_next_node ).to eq(@bNode)
        expect( @aList.get_head.get_next_node.get_next_node ).to eq(@cNode)
        expect( @cNode.get_prev_node ).to eq(@bNode)
        expect( @bNode.get_prev_node ).to eq(@aNode)
        
        @aList.delete_value 2
        
        #expect LinkedList = @aNode -> @cNode
        expect( @aList.get_head ).to eq(@aNode)
        expect( @aList.get_head.get_next_node ).to_not eq(@bNode)
        expect( @aList.get_head.get_next_node ).to eq(@cNode)
        expect( @cNode.get_prev_node ).to_not eq(@bNode)
        expect( @cNode.get_prev_node ).to eq(@aNode)
      end
    end
  end
end