module Enumerable

	def my_each 
		return "#<Enumerator: #{self}:my_each>" unless block_given?
		for i in self 
			yield(i)
		end
		self
	end
	
	def my_each_short 
		return "#<Enumerator: #{self}:my_each_short>" unless block_given?
		self.each {|i| yield(i)}
		self
	end

	def my_each_with_index
		return "#<Enumerator: #{self}:my_each_with_index>" unless block_given?
		self.length.times {|i| yield(self[i], i)}
		self
	end

	def my_select
		return "#<Enumerator: #{self}:my_select>" unless block_given?
		temp=[]
		self.my_each {|i| temp << i if yield(i)}
		temp
	end
	def my_all?
		unless block_given?
			self.my_each {|i| return false unless i}
		else
			self.my_each {|i| return false unless yield(i)}
		end
		return true
	end
	
	def my_any?
		unless block_given?
			self.my_each {|i| return true if i}
		else
			self.my_each {|i| return true if yield(i)}
		end
		return false
	end

	def my_none?
		unless block_given?
			self.my_each {|i| return false if i}
		else
			self.my_each {|i| return false if yield(i)}
		end
		return true
	end
	
	def my_count(*item)
		total = 0
		unless block_given?
			self.my_each {|i| total+=1} if item.my_none?
			self.my_each {|i| total+=1 if i==item[0]} if item.my_any?
		else
			self.my_each {|i| total+=1 if yield(i)}
		end
		return total
	end
	
	def my_map1
		return "#<Enumerator: #{self}:my_map>" unless block_given?
		array=[]
		self.my_each {|i| array << yield(i)}
		array
	end
	
	def my_map(*proc)
		array=[]
		if proc.my_any? && block_given?
			#execute block first, then proc
			temp=[]
			self.my_each {|i| temp << yield(i)}
			temp.my_each {|i| array << proc[0].call(i)}
		elsif proc.my_any?
			self.my_each {|i| array << proc[0].call(i)}
		elsif block_given?
			self.my_each {|i| array << yield(i)}
		else return "#<Enumerator: #{self}:my_map>" unless block_given?
		end
		return array
	end
	
	def my_inject(*params)
		total = self.shift
		total = total.to_f if self.my_any? {|i| i.is_a? Float}
		
		if params.length > 1
			self.unshift(total)
			total = params[0]
			self.my_each {|i| total = total.send(params[1],i)}
		elsif params.one?
			if params[0].is_a? Symbol
				self.my_each {|i| total = total.send(params[0],i)}
			else	#if params is an init
				self.unshift(total)
				total = params[0]
			end
		end
		
		if block_given?
			self.my_each {|i| total = yield(total,i)}
		end
		return total
	end
	
end

def multiply_els(array)
	array.my_inject(:*)
end

=begin
xTest your #my_inject by creating a method called #multiply_els which multiplies all the elements of the array together by using #my_inject, e.g. multiply_els([2,4,5]) #=> 40
xModify your #my_map method to take either a proc or a block, 
	executing the block only if both are supplied (in which case it would execute both the block AND the proc).
=end