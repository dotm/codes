#Largest palindrome product
#A palindromic number reads the same both ways
#largest palindrome made from the product of two 3-digit numbers

def lpp x, y
	original = y
	while x<100
		while y<100
			product = (y * x).to_s
			reversed = product.reverse
			return product if product == reversed
			y-=1
		end
		y=original
		x-=1
	end
end

p lpp 999, 999