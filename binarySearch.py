"""Let min = 1 and max = n.
Guess the average of max and min, rounded down (so that it is an integer).
If you guessed the number, stop. You found it!
If the guess was too low, set min to be one larger than the guess.
If the guess was too high, set max to be one smaller than the guess.
Go back to step 2."""

from random import randint

def bS(mi,ma):
	x=randint(mi,ma)
	langkah=0
	h=(ma+mi)/2
	
	while h!=x:
		if  h>x:
			ma=h
			h=(h+mi)/2
			langkah +=1
		elif h<x:
			mi=h
			h=(ma+h)/2
			langkah+=1
	
	#print x
	return langkah

print bS(1,2040)

#statistic
def stat(mi,ma):
	lala=[]
	for i in range(100):
		lala.append(bS(mi,ma))
	print max(lala)
	print float(sum(lala))/len(lala)
	print min(lala)


raw_input("Press enter to exit. ")