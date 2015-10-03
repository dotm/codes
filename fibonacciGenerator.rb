def fibs(n,a=[0,1])
	return [] 	if n<=0
	a.pop 		if n==1
	if n>2
		a=fibs(n-1,a)
		a << a[n-2]+a[n-3]
	end
	return a
end

p fibs(0)		#[]
p fibs(1)		#[0]
p fibs(2)		#[0,1]
p fibs(3)		#[0,1,1]
p fibs(6)		#[0,1,1,2,3,5]
p fibs(13)		#[0,1,1,2,3,5,8,13,21,34,55,89,144]
p fibs(20)

p fibs(5,[1,1])
p fibs(3,[3,4])