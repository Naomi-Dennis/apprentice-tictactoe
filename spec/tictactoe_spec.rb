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

def is_row_outputed( io: , row:  )
    expect( io.stdout.include? row).to eql true
end

describe TicTacToe do

  context 'when the board is rendered' do
    it 'returns a single list with 9 elements' do
     game = TicTacToe.new(io: FakeIO.new)

     expect(game.render_board.length).to eql 9
    end

  end

  context 'when the game starts the board is empty' do
    it 'sets the board to a list with a single space' do
        game = TicTacToe.new(io: FakeIO.new)
        game.newGame
        expect( game.render_board.all?{ |space| space == ' ' } ).to eql true
    end
  end

 context 'when a single token is placed on an empty board' do
    it 'the token will be "X"' do
      game = TicTacToe.new(io: FakeIO.new)
      expect( game.current_player).to eql 'X'
    end

    it 'the specified space will place the current token on the board' do
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)
      game.place_token(5)

      is_row_outputed(io: fakeIO, row:" | |X")
    end

    it 'the token can be placed anywhere on the board' do
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

      game.place_token(3)
      is_row_outputed(io: fakeIO, row:"X| | " )

      game.newGame
      fakeIO.stdout = []
      game.place_token(5)
      is_row_outputed(io: fakeIO, row: " | |X" )


      game.newGame
      fakeIO.stdout = []
      game.place_token(7)
      is_row_outputed(io: fakeIO, row: " |X| ")
    end

    it 'renders the board after a token is placed' do
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

       game.place_token(3)
       expectedBoardOutput = [" | | ", "------", "X| | ", "------", " | | "]

       expect( fakeIO.stdout ).to eql expectedBoardOutput
    end
  end

  context 'when the user enters a desired position' do
    it 'renders the board with their token' do
      desired_position = 4

      user_input = StringIO.new(desired_position.to_s)
      fakeIO = FakeIO.new( stdin: user_input )
      game = TicTacToe.new(io: fakeIO )

      game.player_turn

      is_row_outputed(io: fakeIO, row: " |X| ")
    end
  end

 context 'when the user tries to place a token in a free space' do
    it 'renders the board with their token in the specified space' do
      desired_position = 4

      user_input = StringIO.new(desired_position.to_s)
      fakeIO = FakeIO.new( stdin: user_input )
      game = TicTacToe.new(io: fakeIO )

      expect(game.render_board[desired_position] ).to eql ' '

      game.player_turn

      is_row_outputed(io: fakeIO, row: " |X| ")
      expect(game.render_board[desired_position]).to eql 'X'
    end
 end
end
