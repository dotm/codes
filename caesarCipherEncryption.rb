def cce (string,x)
	low_case = []
	for i in 'a'..'z'
		low_case << i
	end
	low_alphabet_key_hash = Hash[low_case.map.with_index.to_a]
	
	up_case=[]
	for i in 'A'..'Z'
		up_case << i
	end
	temp = up_case.each_with_index.map { |x,i| [x, i+1000] }
	up_alphabet_key_hash = temp.to_h
	
	number=[]
	string.scan(/./) do |i|
		if low_case.include? i
			number << low_alphabet_key_hash[i]
		elsif up_case.include? i
			number << up_alphabet_key_hash[i]
		else number << i
		end
	end
	
	letter=[]
	number.each do |i|
		if i.is_a? Integer
			i+=x
			if i < 1000
				i=i%26
				letter << low_case[i]
			elsif i >= 1000
				i-=1000
				i=i%26
				letter  << up_case[i]
			end
		else letter << i
		end
	end
	
	puts letter.join
end

def encrypt(string)
	for i in 0..25
		cce(string,i)
	end
end

puts"Enter the sentence(s) you want to encrypt (no more than 256 characters): \n -------------- \n"
lala=gets.chomp
start=Time.new
encrypt(lala)
puts Time.new - start
puts "Press enter to exit. "
gets