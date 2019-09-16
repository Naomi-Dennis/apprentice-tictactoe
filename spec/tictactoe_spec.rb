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
  expect(io.stdout).to include row
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
        expect(all_spaces_empty).to eql true
      end

      it 'the first token will be "X"' do
        game = TicTacToe.new(io: FakeIO.new)
        expect(game.current_player).to eql 'X'
      end
    end
  end

  context 'when a token is placed on an empty board' do
    it 'renders the board after a token is placed' do
      fakeIO = FakeIO.new
      game = TicTacToe.new(io: fakeIO)

      game.place_token(3)
      expectedBoardOutput = [" | | \n------\nX| | \n------\n | | \n"]

      expect(fakeIO.stdout).to eql expectedBoardOutput
    end
  end

  context 'when the user interacts with the board' do
    let(:desired_position) { $desired_position =  4  }

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        fakeIO = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: fakeIO)

        game.begin_player_turn
        user_is_prompted_to_select_space = fakeIO.stdout.grep(/select.*position/i).any?

        expect(user_is_prompted_to_select_space).to eql true
      end

      it 'adds their token to the board' do
        fakeIO = FakeIO.new(stdin: desired_position)
        player_token = 'X'
        game = TicTacToe.new(io: fakeIO)

        updated_board = game.begin_player_turn

        is_row_outputed(io: fakeIO, row:/ \|X\| /)
        expect(updated_board[desired_position]).to eql player_token
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "should prompt the user that it's taken" do
        fakeIO = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: fakeIO)

        game.begin_player_turn

        fakeIO.stdin = desired_position
        game.begin_player_turn

        user_is_prompted_position_taken = fakeIO.stdout.grep(/position.*taken/i).any?
        expect(user_is_prompted_position_taken).to eql true
      end
      it 'should prompt the user to choose another position' do
        fakeIO = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: fakeIO)

        game.begin_player_turn

        fakeIO.stdin = desired_position
        game.begin_player_turn

        user_is_prompted_to_select_space = fakeIO.stdout.grep(/select another position/i).any?
        expect(user_is_prompted_to_select_space).to eql true
      end
    end

    context 'when the user input is invalid' do
      context 'if the input is outside of the specified range' do
        it 'prompt the user to choose another position' do
          fakeIO = FakeIO.new(stdin: -1)
          game = TicTacToe.new(io: fakeIO)

          game.begin_player_turn

          user_is_prompted_position_invalid = fakeIO.stdout.grep(/invalid position/i).any?
          user_is_prompted_to_select_space  = fakeIO.stdout.grep(/select another position/i).any?
          expect(user_is_prompted_to_select_space).to eql true
          expect(user_is_prompted_position_invalid).to eql true
        end

        it 'should not place the token on the board' do
          fakeIO = FakeIO.new(stdin: -1)
          game = TicTacToe.new(io: fakeIO)

          updated_board = game.begin_player_turn

          expect(updated_board.include?('X')).to_not eql true
        end

        it 'should not end the player\'s turn until a valid input is entered' do
          fakeIO = FakeIO.new(stdin: -1)
          game = TicTacToe.new(io: fakeIO)

          player_one_token = game.current_player

          game.begin_player_turn
          expect(game.current_player).to eql player_one_token
          fakeIO.stdin = 5
          game.begin_player_turn

          expect(game.current_player).to_not eql player_one_token
        end

        it 'should re-render the board' do
          fakeIO = FakeIO.new(stdin: -1)
          game = TicTacToe.new(io: fakeIO)

          current_token = game.current_player
          game.begin_player_turn
          expected_board = " | | \n------\n | | \n------\n | | \n"
          expect(fakeIO.stdout).to include expected_board
        end
      end
    end
  end
end
