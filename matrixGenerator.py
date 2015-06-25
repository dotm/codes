matrix=[]
def matrixGen(x,y,list,data):
	for i in range (x):
		list.append([data]*y)
def matrixDis(list):
	for i in list:
		print ' '.join(i)

matrixGen(3,2,matrix,'O')
matrix[0][1]='X'
print matrixDis(matrix)