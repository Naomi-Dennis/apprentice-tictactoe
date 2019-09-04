class TicTacToe

  def initialize(io: )
    @board = Array.new(9, ' ')
    @current_token = 'X'
    @io = io
  end

  def render_board
    io.puts "#{@board[0]}|#{@board[1]}|#{@board[2]}"
    io.puts "------"
    io.puts "#{@board[3]}|#{@board[4]}|#{@board[5]}"
    io.puts "------"
    io.puts "#{@board[6]}|#{@board[7]}|#{@board[8]}"
    board
  end

  def newGame
   @board = Array.new(9, ' ')
  end

 def place_token(position)
    board[position] = current_token
    render_board
 end

 def current_player
    @current_token
 end

 def player_turn
   desired_position = io.gets.to_i
   io.puts "Select a position to place your token [1 - 9]: "

   unless board[desired_position] == ' '
      io.puts "That position is taken!"
   else
    place_token( desired_position )
   end

 end

 private

 attr_accessor :board, :current_token, :io
end
