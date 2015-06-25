from random import randint
from math import log

#Choose minimum number
while True:
	min=raw_input("Choose a minimum number (1 is recommended): ")
	try:
		min=int(min)
		break
	except:
		print "Please choose a number."
#Choose maximum number
while True:
	max=raw_input("Choose a maximum number: ")
	try:
		max=int(max)
		break
	except:
		print "Please choose a number."
#Generate turn and random number
number=randint(min,max)
turn=int((log(max-min)/log(2))+1)
#print number

#Proceed to the Game
while True:
	guess=raw_input("The computer has chosen a number between %s and %s inclusive. Guess the number! You have %s chance(s) left: " % (min,max,turn))
	try:
		guess=int(guess)
		if min<=guess<=max:
			if number==guess:
				print "Congrats!! You win!"
				break
			elif turn==1:
				print "Sorry. You Lose.."
				break
			elif number>guess:
				print "Try Higher!"
			elif number<guess:
				print "Try Lower!"
			turn-=1
		#if guess is out of range
		elif min>guess or guess>max:
			print "Please enter a number between %s and %s inclusive." % (min,max)
	#if raw_input is not an int
	except ValueError:
		print "Please enter a number between %s and %s inclusive." % (min,max)
	
raw_input("Press enter to exit. ")