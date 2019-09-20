# frozen_string_literal: true

require 'spec_helper'
require 'tictactoe'

class FakeIO
  attr_accessor :stdin, :stdout
  def initialize(stdin: '', stdout: [])
    @stdin = stdin
    @stdout = stdout
    @accepted_input = [*1..9].map!(&:to_s)
  end

  def output_to_user(string)
    @stdout << string
  end

  def prompt_user_for_position
    string_to_return = @accepted_input.include?(@stdin) ? @stdin.to_i - 1: nil
    @stdin = ''
    string_to_return
  end
end


def is_row_outputed(io:, row:)
  expect(io.stdout).to include row
end

def create_new_game(io: FakeIO.new, board: TicTacToe::Board.new(layout: Array.new(9, ' ' ) ) )
  TicTacToe.new(io: io, board: board)
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
        io = FakeIO.new(stdin: "1")
        game = create_new_game(io: io)
        game.cycle_player_turn
        current_output = io.stdout
        expect(current_output).to include /Player X/
      end
    end
  end

  context 'when the user interacts with the board' do
    let(:desired_position) { $desired_position =  "5"  }

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        io = FakeIO.new(stdin: desired_position)
        game = create_new_game(io: io)

        game.cycle_player_turn
        current_output = io.stdout

        expect(current_output).to include /select.*position/i
      end

      it 'adds their token to the board' do
        io = FakeIO.new(stdin: desired_position)
        player_token = 'X'
        game = create_new_game(io: io)

        updated_board = game.cycle_player_turn

        is_row_outputed(io: io, row:/ \|X\| /)
      end

      it 'renders the board in a 3x3' do
        io = FakeIO.new(stdin: desired_position)
        game = create_new_game(io: io)

        game.cycle_player_turn
        expectedBoardOutput = " | | \n------\n |X| \n------\n | | \n"

        current_output = io.stdout
        expect(current_output).to include expectedBoardOutput
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "should prompt the user that it's taken" do
        io = FakeIO.new(stdin: desired_position)
        game = create_new_game(io: io)

        game.cycle_player_turn

        io.stdin = desired_position
        game.cycle_player_turn

        current_output = io.stdout

        expect(current_output).to include /select.*position/i
      end
      it 'should prompt the user to choose another position' do
        io = FakeIO.new(stdin: desired_position)
        game = create_new_game(io: io)

        game.cycle_player_turn

        io.stdin = desired_position
        game.cycle_player_turn
        current_output = io.stdout

        expect(current_output).to include /position.*taken/i
      end

      it 'renders the board in a 3x3' do
        io = FakeIO.new(stdin: desired_position)
        game = create_new_game(io: io)

        game.cycle_player_turn

        io.stdin = desired_position
        game.cycle_player_turn

        expected_board_output = " | | \n------\n |X| \n------\n | | \n"
        current_output = io.stdout

        expect(current_output).to include expected_board_output
      end
    end

    context 'when the user input is invalid' do
      let(:bad_input){ "-1" }
      context 'if the input is outside of the specified range' do
        it 'prompt the user to choose another position' do
          io = FakeIO.new(stdin: bad_input)
          game = create_new_game(io: io)

          game.cycle_player_turn

          current_output = io.stdout
          expect(current_output).to include /invalid position/i
          expect(current_output).to include /select another position/i
        end

        it 'should not place the token on the board' do
          io = FakeIO.new(stdin: bad_input)
          game = create_new_game(io: io)

          game.cycle_player_turn
          expected_board_output = " | | \n------\n | | \n------\n | | \n"
          current_output = io.stdout

          expect(current_output).to include expected_board_output
        end

        it "should not end the player\'s turn until a valid input is entered" do
          io = FakeIO.new(stdin: bad_input)
          game = create_new_game(io: io)
          player_one_token = "X"

          game.cycle_player_turn

          io.stdin = "5"
          game.cycle_player_turn

          current_output = io.stdout
          expect(current_output).to_not include /O/
        end

        it 'should re-render the board' do
          io = FakeIO.new(stdin: bad_input)
          game = create_new_game(io: io)

          game.cycle_player_turn

          expected_board = " | | \n------\n | | \n------\n | | \n"
          current_output = io.stdout

          expect(current_output).to include expected_board
        end
      end
    end
  end
end
