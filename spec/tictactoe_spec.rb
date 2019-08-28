require 'spec_helper' 
require 'tictactoe' 
describe TicTacToe do 
  context 'when the game starts the board is empty' do 
    it 'sets the board to a list with empty strings' do 
        game = TicTacToe.new
        game.newGame 
        expect( game.renderBoard.all?{ |space| space.s == '' } ).to eql true
    end 
  end   

end 
