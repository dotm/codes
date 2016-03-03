def add_until_five(x):
	if x >= 5:
		return x
	else:
		print x
		x+=1
		add_until_five(x)
		
def append_x_until_one(x,y):
	if y>0:
		x.append(y)
		print y
		y-=1
		append_x_until_one(x,y)