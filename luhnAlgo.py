#Luhn's Algorithm

num=raw_input("Type your credit card number:\n>>>")
num=str(num)
lala=list(num)

def double(x):
	x=int(x)
	x*=2
	if x<10:
		return x
	else:
		x=str(x)
		x=list(x)
		y=0
		for i in x:
			y+=int(i)
		return y

total=0

for i in range(len(lala)):
	if i%2==0:
		total+=int(double(lala[i]))
	elif i%2==1:
		total+=int(lala[i])
	else:
		assert Exception

print total
if total%10==0:
	print "This credit card is valid"
else:
	print "This credit card is invalid"