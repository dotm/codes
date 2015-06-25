#Direction words: north, south, east, west, down, up, left, right, back
direction={
	'north':('direction', 'north'),	'south':('direction', 'south'),
	'east':('direction', 'east'),	'west':('direction', 'west'),
	'down':('direction', 'down'),	'up':('direction', 'up'),
	'left':('direction', 'left'),	'right':('direction', 'right'),
	'back':('direction', 'back')}

#Verbs: go, stop, kill, eat
verbs={
	'go':('verb','go'),			'stop':('verb','stop'),
	'kill':('verb','kill'),		'eat':('verb','eat')}

#Stop words: the, in, of, from, at, it
stops={
	'the':('stop','the'), 'in':('stop','in'), 'of':('stop','of'), 
	'from':('stop','from'), 'at':('stop','at'), 'it':('stop','it')
}

#Nouns: door, bear, princess, cabinet
nouns={
	'door':('noun','door'), 'bear':('noun','bear'), 'princess':('noun','princess'), 'cabinet':('noun','cabinet')
}

#Numbers: any string of 0 through 9 characters

#stuff = raw_input('> ')
#words = stuff.split()

def dir(s):
	if s in direction:
		return direction[s]
	else: 
		return False 

def verb(s):
	if s in verbs:
		return verbs[s]
	else: 
		return False 

def stop(s):
	if s in stops:
		return stops[s]
	else: 
		return False 
	
def noun(s):
	if s in nouns:
		return nouns[s]
	else: 
		return False 
		
def scan(stuff_):
	words_=stuff_.split()
	temp=[]
	
	#check where a word in words_ belongs in the dictionaries above
	for s in words_:
		if dir(s)!=False:
			temp.append(dir(s))
		elif verb(s)!=False:
			temp.append(verb(s))
		elif stop(s)!=False:
			temp.append(stop(s))
		elif noun(s)!=False:
			temp.append(noun(s))
		else:
			try:
				temp.append(('number',int(s)))
			except ValueError:
				temp.append(('error',s))
		
	return temp
