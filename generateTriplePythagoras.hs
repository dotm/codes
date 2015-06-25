--Generate Triple Pythagoras
triple = [ (a,b,c) | c <- [1..100], b <- [1..100], a <- [1..100], a^2+b^2==c^2, a<b, b<c, lala a b c==True]

{-check whether the triple is not a multiplied version of another triple
	e.g. (3,4,5)	->	True
		 (6,8,10)	->	False
-}
lala a b c = null[ x | x <- [2..c - 1], a`mod`x==0 && b`mod`x==0 && c`mod`x==0]

{-	you can search for a triple of a triangle with a specific known perimeter by adding
		a+b+c= perimeterLength
	to the predicate (perimeterLength is a number)
	and erasing
		lala a b c==True
-}