require 'spec_helper' 
require 'tictactoe' 

## Faker Classes 
class FakeIO
  attr_accessor :stdin, :stdout 
  def initialize(stdin: StringIO.new('') ) 
      @stdin = stdin 
      @stdout = []  
  end 

  def puts( string ) 
    @stdout << string     
  end 

  def gets 
    @stdin.gets @stdin.string 
  end 
end 

def isRowOutputed( io, row ) 
    expect( io.stdout.includes? row).to eql true 
def isRowOutputed( io: , row:  ) 
    expect( io.stdout.include? row).to eql true 
end 

describe TicTacToe do 

  context 'when the board is viewed' do
    it 'returns a single list with 9 elements' do 
     game = TicTacToe.new(io: FakeIO.new)

     expect(game.renderBoard.length).to eql 9

     game = TicTacToe.new(io: FakeIO.new)

     expect(game.renderBoard.all?{ |space| space.class == String && space.length == 1 } ).to eql true 
    end

  end

  context 'when the game starts the board is empty' do 
    it 'sets the board to a list with a single space' do 
        game = TicTacToe.new(io: FakeIO.new)
        game.newGame 
        expect( game.renderBoard.all?{ |space| space == ' ' } ).to eql true
    end 
  end  

 context 'when a single token is placed on an empty board' do 
    it 'the token will be "X"' do 
      game = TicTacToe.new(io: FakeIO.new) 
      expect( game.currentPlayer).to eql 'X' 
    end

    it 'the specified space will place the current token on the board' do 
      fakeIO = FakeIO.new 
      game = TicTacToe.new(io: fakeIO)  
      game.placeToken(5) 
      
      expectedRowOutput = " |X| " 
      expect( fakeIO.stdout.include? expectedRowOutput ).to eql true 
      isRowOutputed(io: fakeIO, row:" |X| ") 
    end

    it 'the token can be placed anywhere on the board' do 
      game = TicTacToe.new(io: FakeIO.new) 
      fakeIO = FakeIO.new
      expectedRowOutput = ""
      game = TicTacToe.new(io: fakeIO)
      game.placeToken(3) 
      expect( game.renderBoard[2] ).to eql 'X' 
      expectedRowOutput = " | |X" 
      expect( fakeIO.stdout.include? expectedRowOutput ).to eql true 
      
      game.newGame 
      game.placeToken(5)

      expect(game.renderBoard[4]).to eql 'X' 

      game.newGame 
      game.placeToken(9)
      expect(game.renderBoard[8]).to eql 'X' 
      game.placeToken(3)
      isRowOutputed(io: fakeIO, row:" | |X" )  
      
      game.newGame
      fakeIO.stdout = []
      game.placeToken(5)  
      expectedRowOutput = " |X| " 
      expect( fakeIO.stdout.include? expectedRowOutput ).to eql true 
      game.placeToken(5) 
      isRowOutputed(io: fakeIO, row: " |X| " )
      
      
      game.newGame
      fakeIO.stdout = []  
      game.placeToken(7)
      expectedRowOutput = "X| | "
      expect(fakeIO.stdout.include? expectedRowOutput ).to eql true
      isRowOutputed(io: fakeIO, row: "X| | ") 
    end 
    
    it 'renders the board after a token is placed' do 
      game = TicTacToe.new(io: FakeIO.new) 
      updatedBoard = game.placeToken(3) 
      expect( updatedBoard[2] ).to eql 'X'    
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

       game.placeToken(3)
       expectedBoardOutput = [" | |X", "------", " | | ", "------", " | | "]

       expect( fakeIO.stdout ).to eql expectedBoardOutput
    end   
  end  

  context 'when the user enters a desired position' do 
    it 'renders the board with their token' do 
      game = TicTacToe.new(io: FakeIO.new)
      
      updatedBoard = game.playerTurn StringIO.new('4');

      expect( updatedBoard.include? 'X'  ).to eql true
    end 
  end 

 context 'when the user tries to place a token in a free space' do 
    it 'renders the board with their token in the specified space' do 
      game = TicTacToe.new(io: FakeIO.new)
      currentPlayer = game.currentPlayer 
      updatedBoard = game.placeToken 4 
      expect( game.placeToken(4)[3] ).to eql currentPlayer 
    end 
 end 
 
  
 

end 
