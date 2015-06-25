"""while True:
    for i in ["/","-","|","\\","|"]:
        print "%s\r" % i,
"""
q="o          x"
w="+>         x"
e="+->        x"
r="+-->       x"
t="+--->      x"
y="+ --->     x"
u="+  --->    x"
i="+   --->   x"
o="+    --->  x"
p="+     ---> x"
a="+      --->x"

lala=[q,w,e,r,t,y,u,i,o,p,a]

while True:
	global lala
	for i in lala:
		print "%s\r" % i,

"""
.\|/.
--*--
'/|\'"""