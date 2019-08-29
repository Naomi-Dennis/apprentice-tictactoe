class TicTacToe
   
  def initialize
    @board = Array.new(9, '') 
    @currentToken = 'X' 
  end 

  def renderBoard 
    board 
  end 
  
  def newGame
    board = Array.new(9, '') 
  end

 def placeToken(position) 
    board[position - 1] = currentToken  
    renderBoard  
 end

 def currentPlayer 
    @currentToken 
 end

 def playerTurn( io=STDIN )
   desiredPosition = io.gets.chomp.to_i
   placeToken( desiredPosition )  
 end

 private 

 attr_accessor :board, :currentToken 
end 
