require 'spec_helper' 
require 'tictactoe' 
describe TicTacToe do 
  context 'when the board is viewed' do
    it 'returns a single list with 9 elements' do 
     game = TicTacToe.new

     expect(game.renderBoard.length).to eql 9
    end 

    it 'returns a list of all strings' do 
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

end 
