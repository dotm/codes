class Board

	def initialize
		#Init 3x3 board
		@board = [[[],[],[]],[[],[],[]],[[],[],[]]]
		@turn = 1
		@win = false
	end

	def board_full?
		for row in 0..2
			for collumn in 0..2
				unless @board[row][collumn].any?
					return false
					break
				end
			end
		end
		return true
	end
	
	def any_win?
		if @board[1][1].any?
			if @board[1][0] == @board[1][1]
				if @board[1][2] == @board[1][1]
					@win = @board[1][1]
					return true
				end
			elsif @board[0][1] == @board[1][1]
				if @board[1][1] == @board[2][1]
					@win = @board[1][1]
					return true
				end
			elsif @board[0][0] == @board[1][1]
				if @board[1][1] == @board[2][2]
					@win = @board[1][1]
					return true
				end
			elsif @board[0][2] == @board[1][1]
				if @board[1][1] == @board[2][0]
					@win = @board[1][1]
					return true
				end
			end
		end
		if @board[0][0].any?
			if @board[0][0] == @board[1][0]
				if @board[1][0] == @board[2][0]
					@win = @board[0][0]
					return true
				end
			elsif @board[0][0] == @board[0][1]
				if @board[0][1] == @board[0][2]
					@win = @board[0][0]
					return true
				end
			end
		end
		if @board[2][2].any?
			if @board[2][1] == @board[2][2]
				if @board[2][1] == @board[2][0]
					@win = @board[2][2]
					return true
				end
			elsif @board[2][2] == @board[1][2]
				if @board[1][2] == @board[0][2]
					@win = @board[2][2]
					return true
				end
			end
		else return false
		end
	end
	
	def show_board
		#try to use string formatting %i
		for i in @board
		puts "#{i[0]}\t#{i[1]}\t#{i[2]}"
		end
	end
	
	def cell_setter(row, collumn, player)
		#input first index is 1
		row = row-1
		collumn = collumn-1
		
		@board[row][collumn] << player
	end
	
	def take_input x
		while true
			puts "Player #{x} turn: (row,collumn)"
			input = gets.chomp
			input = input.scan(/\d/)
			if @board[(input[0].to_i)-1][(input[1].to_i)-1].none?
				cell_setter(input[0].to_i,input[1].to_i,x)
				break
			else puts "That cell is already filled. Pick another cell."
			end
		end
	end

	def initialize_game
		#if board not full and no wins continue
		while true
			if board_full?
				puts "It's a tie! Game Over!"
				break
			elsif any_win?
				puts "Game Over! Player #{@win[0]} win!"
				break
			else
				if @turn.odd?
					take_input 1
				elsif @turn.even?
					take_input 2
				end
				show_board
				@turn += 1
			end
		end
	end
end

#for testing
a = Board.new
a.initialize_game
