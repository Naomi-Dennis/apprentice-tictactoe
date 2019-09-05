# frozen_string_literal: true

require 'spec_helper'
require 'tictactoe'

class FakeIO
  attr_accessor :stdin, :stdout
  def initialize(stdin: '', stdout: [])
    @stdin = stdin
    @stdout = stdout
  end

  def puts(string)
    @stdout << string
  end

  def gets
    string_to_return = @stdin
    @stdin = ''
    string_to_return
  end
end

def is_row_outputed(io:, row:)
  expect(io.stdout.include?(row)).to eql true
end

describe TicTacToe do
  context 'when a new game is started' do
    context 'when the board is rendered' do
      it 'returns a single list with 9 elements' do
        game = TicTacToe.new(io: FakeIO.new)

        expect(game.render_board.length).to eql 9
      end
    end

    context 'when the board is empty' do
      it 'sets board data to empty spaces' do
        game = TicTacToe.new(io: FakeIO.new)
        all_spaces_empty = game.render_board.all? { |space| space == ' ' }
        expect( all_spaces_empty ).to eql true
      end

      it 'the first token will be "X"' do
        game = TicTacToe.new(io: FakeIO.new)
        expect(game.current_player).to eql 'X'
      end
    end
  end

  context 'when a token is placed on an empty board' do
    it 'the token can be placed anywhere on the board' do
      first_desired_position = 3
      second_desired_position = 5
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

      game.place_token(first_desired_position)
      updated_board = game.place_token(second_desired_position)

      is_row_outputed(io: fakeIO, row: 'X| | ')
      is_row_outputed(io: fakeIO, row: 'X| |X')
      expect(updated_board[first_desired_position] && updated_board[second_desired_position]).to eql 'X'
    end

    it 'renders the board after a token is placed' do
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

      game.place_token(3)
      expectedBoardOutput = [' | | ', '------', 'X| | ', '------', ' | | ']

      expect(fakeIO.stdout).to eql expectedBoardOutput
    end
  end

  context 'when the user interacts with the board' do

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        fakeIO = FakeIO.new( stdin: desired_position )
        game = TicTacToe.new( io: fakeIO )

        game.begin_player_turn
        user_is_prompted_to_select_space  = fakeIO.stdout.grep(/[S|s]elect.*position/).any?

        expect( user_is_prompted_to_select_space ).to eql true
      end

      it 'adds their token to the board' do
        fakeIO = FakeIO.new( stdin: desired_position )
        player_token = 'X'
        game = TicTacToe.new(io: fakeIO)

        updated_board = game.begin_player_turn

        is_row_outputed(io: fakeIO, row: " |#{player_token}| ")
        expect( updated_board[desired_position] ).to eql player_token
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "should prompt the user that it's taken" do
        fakeIO = FakeIO.new( stdin: desired_position )
        game = TicTacToe.new(io: fakeIO)

        game.begin_player_turn

        fakeIO.stdin = desired_position
        game.begin_player_turn

        expect(fakeIO.stdout.include?('That position is taken!')).to eql true
      end
    end
  end
end
