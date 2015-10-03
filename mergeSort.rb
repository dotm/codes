module Enumerable
	def split
		a=self.pop(self.length-self.length/2)
		return self,a
	end
end

def merge_sort array
	if array.length > 1 
		a1,a2=array.split 
		merge(merge_sort(a1),merge_sort(a2))
	elsif array.length == 1 
		return array
	end
end

def merge a1, a2
	a0=[]
	while a1.any? && a2.any?
		a0 << (a1[0] < a2[0] ? a1 : a2).shift	#compare, pop the first element with the least number, push to a0
	end
	a0.concat a2 if a1.none?
	a0.concat a1 if a2.none?
	return a0
end

p merge_sort [1]						#1
p merge_sort [1,0]						#0,1
p merge_sort [1,0,9,4]					#0,1,4,9
p merge_sort [1,0,4,9,2]				#0,1,2,4,9
p merge_sort [1,0,4,9,2,5,3,6,8,7]		#0,1,2,3,4,5,6,7,8,9

p merge [3],[2]							#2,3
p merge [3],[2,9,10]					#2,3,9,10
p merge [3,8,9],[2]						#2,3,8,9

