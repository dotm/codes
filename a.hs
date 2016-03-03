abjad=['a'..'z']
--nomor=[0..25]
--lala=zip abjad nomor


{-
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
-----------------------------------------------------------------------
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
-}