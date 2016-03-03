'''
Thumb Guess Games
Rule:
	Every player start with two thumb finger
	Every round one player will call a number 
		and simultaneously all the player raise any number of thumb(s) they still have
	If the number called is equal to the total number of thumbs raised
		the player who call the number win the round and s/he must draw one thumb out of the game
	The game then proceed to the next round, the next player will then call a number
	The game end when one player have no thumbs left in the game
		or when all but one player have no thumbs left in the game

Pseudocode:
	use raw_input to ask number of player (human and computer)
	use for loop to instantiate Player

	all players initially have 2 fingers
	while no player have 0 finger
		play rounds							#make 2 different round: one for human, one for computer
			ask for ask() and guess()
			if total==guess
			finger -=1
		computer guess
			use randint to guess up to the maximum total possible (make sure to count their finger choice~total-finger not up)
			make sure they don't guess lower than they ask

add a new variable beside round to initialize round other than human
make multi-player
'''
from random import randint

class Player(object):
	def __init__(self,name):
		self.name=name
		self.fingers=2
		self.choice=0
		self.guess=None

#use raw_input to get Human ask() and guess()
class Human(Player):
	def __init__(self,name):
		self.name=name
		self.fingers=2
		self.choice=0
		self.call=None
	
	def ask(self):
		while True:
			temp=raw_input("ask> ")
			try:
				temp=int(temp)
				if temp in range(3):
					self.choice=temp
					return temp
					break
				else:
					print "Please enter a number between 0 and 2 inclusive."
			except:
				print "Please enter a number between 0 and 2 inclusive."

	def guess(self):
		global total
		while True:
			temp=raw_input("guess> ")
			try:
				self.call=temp=int(temp)
				print '%s call %s'%(self.name,self.call)
				if temp==total:
					self.fingers-=1
					print '%s win this round!'%(self.name)
					break
				else:
					print 'Oops.. next round'
					break
			except:
				print "Please enter a number."

#use randint to get Computer ask() and guess()
class Computer(Player):
	def __init__(self,name):
		self.name=name
		self.fingers=2
		self.choice=0
		self.call=None
		
	def ask(self):
		self.choice=randint(0,2)
		return self.choice
	
	def guess(self):
		global total
		ceiling=int(sum(all_fingers))
		floor=int(self.choice)
		self.call=randint(floor,ceiling)
		print '%s call %s'%(self.name,self.call)
		if self.call==total:
			self.fingers-=1
			print '%s win this round!'%(self.name)
		else:
			print 'Oops.. next round'
			
#create players and initialize game
human1=Human('Yoshua')
computer1=Computer('Computer1')
all_players=[human1,computer1]					#redundant?
all_fingers=[human1.fingers,computer1.fingers]	#used in computer.ask() and while loop
round=1											#used to count round in table

#winning condition
def end(list):
	if 0 in list:
		return True
	else:
		return False

#start the game
while end(all_fingers)==False:
	#call round
	human1.choice=human1.ask()
	computer1.choice=computer1.ask()

	#total count round
	all_choice=[human1.choice,computer1.choice]
	total=sum(all_choice)
	
	#guess round
	if round%2==1:
		human1.guess()
	elif round%2==0:
		computer1.guess()

	#used in table
	all_fingers=[human1.fingers,computer1.fingers]
	
	#make a table to keep data per round
	title='Round %s'%(round)
	header='Player Name \t|Choice \t|Fingers Left'
	row1='%s \t\t|%s \t\t|%s'%(human1.name,human1.choice,human1.fingers)
	row2='%s \t|%s \t\t|%s'%(computer1.name,computer1.choice,computer1.fingers)
	footer='Total \t\t|%s \t\t|%s'%(total,sum(all_fingers))
	table='\n'+title+'\n'+header+'\n'+row1+'\n'+row2+'\n'+footer+'\n'
	print table

	round+=1
else:
	#print the winner
	print "Game Over!"
	for i in range(len(all_fingers)):
		if all_fingers[i]==0:
			print '%s win the game!'%(all_players[i].name)
