class TicTacToe
   
  def initialize(io: )
    @board = Array.new(9, ' ') 
    @currentToken = 'X' 
    @io = io
  end 

  def renderBoard 
    puts "#{@board[0]}|#{@board[1]}|#{@board[2]}"
    puts "------"
    puts "#{@board[3]}|#{@board[4]}|#{@board[5]}"
    puts "------"
    puts "#{@board[6]}|#{@board[7]}|#{@board[8]}"
    board 
  end 
  
  def newGame
    board = Array.new(9, ' ') 
  end

 def placeToken(position) 
    board[position - 1] = currentToken  
    renderBoard  
 end

 def currentPlayer 
    @currentToken 
 end

 def playerTurn( io=STDIN )
   desiredPosition = io.gets.to_i
   io.puts "Select a position to place your token [0 - 9]: "

   unless board[desiredPosition - 1] == ' ' 
      io.puts "That position is taken!" 
   else
    placeToken( desiredPosition )  
   end
   
 end


 private 

 attr_accessor :board, :currentToken, :io 
end 
