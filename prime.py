a=[]

from math import sqrt

def largest_prime(x):
	global a
	max = sqrt(x)
	factor = 1
	for i in a:
		if i > max:
			break
		elif x%i==0:
			factor = i
	return factor
		
