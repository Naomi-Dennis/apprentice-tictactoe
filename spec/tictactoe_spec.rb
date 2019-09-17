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
        io = FakeIO.new
        game = TicTacToe.new(io: io)

        game.place_token(1)

        current_output = io.stdout
        expect(current_output).to include /X/
      end
    end
  end

  context 'when a token is placed on an empty board' do
    it 'renders the board in a 3x3 after a token is placed' do
      io = FakeIO.new
      game = TicTacToe.new(io: io)

      game.place_token(3)
      expectedBoardOutput = [" | | \n------\nX| | \n------\n | | \n"]

      expect(io.stdout).to eql expectedBoardOutput
    end
  end

  context 'when the user interacts with the board' do
    let(:desired_position) { $desired_position =  4  }

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)

        game.begin_player_turn
        current_output = io.stdout

        expect(current_output).to include /select.*position/i
      end

      it 'adds their token to the board' do
        io = FakeIO.new(stdin: desired_position)
        player_token = 'X'
        game = TicTacToe.new(io: io)

        updated_board = game.begin_player_turn

        is_row_outputed(io: fakeIO, row:/ \|X\| /)
        expect(updated_board[desired_position]).to eql player_token
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "should prompt the user that it's taken" do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)

        game.begin_player_turn

        io.stdin = desired_position
        game.begin_player_turn

        current_output = io.stdout

        expect(current_output).to include /select.*position/i
      end
      it 'should prompt the user to choose another position' do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)

        game.begin_player_turn

        io.stdin = desired_position
        game.begin_player_turn
        current_output = io.stdout

        expect(current_output).to include /position.*taken/i
      end
    end

    context 'when the user input is invalid' do
      let(:bad_input){ "-1" }
      context 'if the input is outside of the specified range' do
        it 'prompt the user to choose another position' do
          io = FakeIO.new(stdin: bad_input)
          game = TicTacToe.new(io: io)

          game.begin_player_turn

          current_output = io.stdout
          expect(current_output).to include /invalid position/i
          expect(current_output).to include /select another position/i
        end

        it 'should not place the token on the board' do
          io = FakeIO.new(stdin: bad_input)
          game = TicTacToe.new(io: io)

          updated_board = game.begin_player_turn

          expect(updated_board).to_not include /X/
        end

        it "should not end the player\'s turn until a valid input is entered" do
          io = FakeIO.new(stdin: bad_input)
          game = TicTacToe.new(io: io)
          player_one_token = "X"

          game.begin_player_turn

          io.stdin = "5"
          game.begin_player_turn

          current_output = io.stdout
          expect(current_output).to_not include /O/
        end

        it 'should re-render the board' do
          io = FakeIO.new(stdin: bad_input)
          game = TicTacToe.new(io: io)

          game.begin_player_turn

          expected_board = " | | \n------\n | | \n------\n | | \n"
          current_output = io.stdout

          expect(current_output).to include expected_board
        end
      end
    end
  end
end
