#Stacks
class Stack
  #You can implement a stack internally using an array
  def initialize max=false
    @stack = []
    #You can limit the length of the array to create a fixed-length stack (use a "max" variable)
    if max then @max = max end
    #Use a "top" variable to store total elements in the stack
    @top = 0
  end
  
  #STACK-EMPTY operation
  def empty?
    #return true if top is 0
    if @top==0 
      return true
    #return false is top is greater than 0
    elsif @top > 0
      return false
    #return error if top is less than 0 (logically impossible)
    else
      raise Exception
    end
  end
  
  #INSERT operation (PUSH)
  def push element
    #if the maximum amount of a fixed-length stack is achieved ("top" >= "max"), return a STACK-OVERFLOW error
    if @max && @top >= @max then return "STACK-OVERFLOW" end
    #add element to the top of the stack
    @stack[@top] = element
    #increment the "top" variable
    @top += 1
    #You can return the stack so that you can chain methods
    return self
  end
  
  #DELETE operation (POP)
  def pop
    #if the stack is empty, return a STACK-UNDERFLOW error
    if empty? then return "STACK-UNDERFLOW" end
    #the top element is at "top" variable - 1 (the length of stack's array - 1) if array is zero-indexed
    top = @top-1
    #store the top element on a temporary variable
    temp = @stack[top]
    #delete the top element
    @stack.delete_at top
    #decrement the "top" variable
    @top -= 1
    #return the (temporarily) stored element
    return temp
  end
end