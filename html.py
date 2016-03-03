from sys import argv
script, filename=argv

blank="""
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
	<!-- <link href='stylesheet.css' type='text/css' rel='stylesheet'>
	-->
        <title>New Webpage</title>
    </head>
    <body>


    </body>
</html>
"""

file=open(filename,'a')

file.write(blank)

file.close()