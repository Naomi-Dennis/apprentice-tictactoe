require 'spec_helper' 
require 'tictactoe' 
describe TicTacToe do 
  context 'when the board is viewed' do
    it 'returns a single list with 9 elements' do 
     game = TicTacToe.new

     expect(game.renderBoard.length).to eql 9

     game = TicTacToe.new

     expect(game.renderBoard.all?{ |space| space.class == String && space.length <= 1 } ).to eql true 
    end 
  end

  context 'when the game starts the board is empty' do 
    it 'sets the board to a list with empty strings' do 
        game = TicTacToe.new
        game.newGame 
        expect( game.renderBoard.all?{ |space| space == '' } ).to eql true
    end 
  end  

 context 'when a single token is places on an empty board' do 
    it 'the token will be "X"' do 
      game = TicTacToe.new 
      expect( game.currentPlayer).to eql 'X' 
    end 
    it 'the specified space will place the current token on the board' do 
      game = TicTacToe.new 
      game.placeToken(5) 
      expect( game.renderBoard[4] ).to eql 'X' 
    end

    it 'the token can be placed anywhere on the board' do 
      game = TicTacToe.new 
      game.placeToken(3) 
      expect( game.renderBoard[2] ).to eql 'X' 
      
      game.newGame 
      game.placeToken(5)

      expect(game.renderBoard[4]).to eql 'X' 

      game.newGame 
      game.placeToken(9)
      expect(game.renderBoard[8]).to eql 'X' 
    end 

    it 'renders the board after a token is placed' do 
      game = TicTacToe.new 
      updatedBoard = game.placeToken(3) 
      expect( updatedBoard[2] ).to eql 'X' 
      
    end   
  end  



end 
