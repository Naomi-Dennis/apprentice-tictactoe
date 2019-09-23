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

  def current_output
    @stdout
  end
end

def is_row_outputed(io:, row:)
  expect(io.stdout).to include row
end

describe TicTacToe do
  context 'when a new game is started' do
    it 'the first token will be "X"' do
      io = FakeIO.new
      game = TicTacToe.new(io: io)
      game.place_token(1)
      expect(io.current_output).to include(/X/)
    end
  end

  context 'when a token is placed on an empty board' do
    it 'render the board in a 3x3 after a token is placed' do
      io = FakeIO.new
      game = TicTacToe.new(io: io)
      game.place_token(3)
      expected_board_output = " | | \n------\nX| | \n------\n | | \n"
      expect(io.current_output).to include expected_board_output
    end
  end

  context 'when the user interacts with the board' do
    let(:desired_position) { '4' }

    def simulate_turn_with_input(game:, io:, input:)
      io.stdin = input
      game.begin_player_turn
    end

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)
        simulate_turn_with_input(game: game, io: io, input: desired_position)
        expect(io.current_output).to include(/select.*position/i)
      end

      it 'adds their token to the board' do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)
        game.begin_player_turn
        is_row_outputed(io: io, row: / \|X\| /)
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "prompt the user that it's taken" do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)
        game.begin_player_turn
        expect(io.current_output).to include(/select.*position/i)
      end
      it 'prompt the user to choose another position' do
        io = FakeIO.new(stdin: desired_position)
        game = TicTacToe.new(io: io)
        game.begin_player_turn
        simulate_turn_with_input(game: game, io: io, input: desired_position)
        expect(io.current_output).to include(/position.*taken/i)
      end
    end

    context 'when the input is outside of the specified range' do
      let(:bad_input) { '-1' }

      it 'prompt the user to choose another position' do
        io = FakeIO.new(stdin: bad_input)
        game = TicTacToe.new(io: io)
        game.begin_player_turn
        expect(io.current_output).to include(/invalid position/i,
                                             /select another position/i)
      end

      it 'do not place the token on the board' do
        io = FakeIO.new(stdin: bad_input)
        game = TicTacToe.new(io: io)

        game.begin_player_turn
        expect(io.current_output).not_to include(/X/)
      end

      it "not end the player's turn until a valid input is entered" do
        io = FakeIO.new(stdin: bad_input)
        game = TicTacToe.new(io: io)

        simulate_turn_with_input(game: game, io: io, input: '5')
        expect(io.current_output).not_to include(/O/)
      end
    end

    context "when the player's turn ends" do
      it 're-render the board' do
        io = FakeIO.new(stdin: '0')
        game = TicTacToe.new(io: io)
        game.begin_player_turn
        expected_board = " | | \n------\n | | \n------\n | | \n"
        expect(io.current_output).to include expected_board
      end
    end
  end
end
