def bubble_sort (a)
	(a.length).times do
		(a.length - 1).times do |i| 
			if a[i] > a[i+1] 
				a[i], a[i+1] = a[i+1], a[i]
			end
		end
	end
	a
end

p bubble_sort([4,3])
p bubble_sort([4,3,78,2,0,2])
