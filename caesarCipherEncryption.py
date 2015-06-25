'''
Caesar Cipher Encryption
The Pseudo Code

	define a string

	make function that does this stuff:
		push every letter individually into an array
		use conditional to convert every letter into number
		add every number with an integer
		convert added number back into letter
		combine every letter into one string		~use length

	execute the above function 26 time
	print every results

The BETA version

	sentence="yoshua"
	def cce(kalimat,x):
		after=[]
		for i in kalimat:
			after.append(i)
		number=[]
		for i in after:
			i=abjad.index(i)
			number.append(i)
		toLetter=[]
		for i in number:
			i+=x
			i%=25
			toLetter.append(abjad[i])
		finish=''.join(toLetter)
		return finish

	def complete(kalimat):
		for i in range (0,25):
			cce(kalimat,i)
			
	print complete(sentence)
'''

abjad=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
def is_int(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

def ccce(kalimat,x):
	number=[]
	for i in kalimat:
		if i in abjad:
			i=abjad.index(i)
			number.append(i)
		else:
			number.append(i)
	letter=[]
	for i in number:
		if is_int(i)==True:
			i+=x
			i%=26
			letter.append(abjad[i])
		else:
			letter.append(i)
	finish=''.join(letter)
	print finish

def encrypt(kalimat):
	for i in range (0,26):
		ccce(kalimat,i)

lala=(raw_input("Enter the sentence(s) you want to encrypt (Please don't enter number!): \n -------------- \n")).lower()

encrypt(lala)
raw_input("Press enter to exit. ")