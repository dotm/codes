'''
	!!!!!!!!!!! Don't us i for iterator !!!!!!!!!!!!!
	
	#Basic halfAdder function
	def hA(a,b):
		s=a^b
		c=a&b
		return s,c

	i=0	#input can also be 1 if i=o (see below); used in fA below
	o=0	#the assignment is not important, will be overwritten by the fullAdder function

	#Basic fullAdder function
	def fA(a,b):
		global i_, i_b, o_
		i_b=i_
		s1,c1=hA(a,b)
		s2,c2=hA(i_,s1)	#i is carry input
		s=s2
		o_=c2|c1			#o is carry output
		i_=o_				#the output of a fullAdder can be used by the next fullAdder
		return s			#the o is not returned, it's already in global variable o
				
'''

#HalfAdder class
class HalfAdder(object):
		def __init__(self,a,b):
			self.a=a
			self.b=b
		#hA (halfAdder) function using input from __init__
		def hA(self,a,b):
			s=a^b
			c=a&b
			return s,c

#an instance of HalfAdder (scaffold)
'''HA11=HalfAdder(1,1)
print HA11.hA()
'''

class FullAdder(HalfAdder):
	i_ = o_= i_b = 0						#initialize I/O of carry
	def __init__(self,a,b):
		self.a=a
		self.b=b
	def fA(self):
		FullAdder.i_b = FullAdder.i_		#used as scaffold
		s1,c1=self.hA(self.a, self.b)
		s2,c2=self.hA(FullAdder.i_,s1)
		s=s2	#optional (see line 50)
		FullAdder.o_=c2|c1
		FullAdder.i_=FullAdder.o_
		return s
	
#an instance of FullAdder chain (scaffold)
'''
FA1=FullAdder(1,1)
FA2=FullAdder(1,1)
FA1.fA()
print FullAdder.i_b,FullAdder.o_
FA2.fA()
print FullAdder.i_b,FullAdder.o_
FA1.fA()
print FullAdder.i_b,FullAdder.o_
'''