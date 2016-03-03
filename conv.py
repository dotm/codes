import re

x = raw_input()
imperial = re.search('[\d+\']\s[\d+\"]', x)
metric = re.search('^\d+$', x)

if imperial:
	x = x.split()
	a = int(x[0]) * 30.48
	b = int(x[1]) * 2.54
	cm = a + b
	print "%s\' %s\" is %scm"% (x[0], x[1], cm)
elif metric:
	feet, mod = divmod(float(x), 30.48)
	inches = mod / 2.54
	print "%scm is %i' %.2f\"" % (x, feet, inches)