class TicTacToe

  def initialize(io: )
    @board = Array.new(9, ' ')
    @currentToken = 'X'
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

 def placeToken(position)
    board[position] = currentToken
    render_board
 end

 def currentPlayer
    @currentToken
 end

 def player_turn
   desiredPosition = io.gets.to_i
   io.puts "Select a position to place your token [1 - 9]: "

   unless board[desiredPosition] == ' '
      io.puts "That position is taken!"
   else
    placeToken( desiredPosition )
   end

 end

 private

 attr_accessor :board, :currentToken, :io
end
