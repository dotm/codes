def onlyLetters(text): 
	text = text.lower() 
	result = "" 
	for let in text: 
		if let>='a' and let <='z': 
			result += let 
	return result 

def main(): 
	print (onlyLetters ("Was it a car or a cat I saw?")) 
