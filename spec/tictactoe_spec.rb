# frozen_string_literal: true

require 'spec_helper'
require 'tictactoe'
require 'board'
require 'presenter'

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

describe TicTacToe do
  let(:blank_board_output) { "1|2|3\n------\n4|5|6\n------\n7|8|9\n" }

  def create_game(io:, board: Board.new(layout: [*1..9].map(&:to_s)))
    TicTacToe.new(io: io, board: board, presenter: Presenter.new(io: io))
  end

  def board_output_with(token:, position:)
    blank_board_output.sub(position.to_s, token)
  end

  context 'when a new game is started' do
    it 'the first token will be "X"' do
      io = FakeIO.new
      game = create_game(io: io)
      game.place_token(1)
      game.render_board
      expect(io.current_output).to include(/X/)
    end
  end

  context 'when a token is placed on an empty board' do
    it 'render the board in a 3x3 after a token is placed' do
      io = FakeIO.new
      game = create_game(io: io)
      game.place_token(3)
      game.render_board
      expected_board_output = board_output_with(token: 'X', position: 3)
      expect(io.current_output).to include expected_board_output
    end
  end

  context 'when the user interacts with the board' do
    let(:test_position) { '4' }

    def simulate_turn_with_input(game:, io:, input:)
      io.stdin = input
      game.begin_player_turn
    end

    context 'when the user tries to place a token in a free space' do
      it 'prompt the user to select a space' do
        io = FakeIO.new(stdin: test_position)
        game = create_game(io: io)
        simulate_turn_with_input(game: game, io: io, input: test_position)
        expect(io.current_output).to include(/select.*position/i)
      end

      it 'adds their token to the board' do
        io = FakeIO.new(stdin: test_position)
        game = create_game(io: io)
        game.begin_player_turn
        board_with_token = board_output_with(token: 'X', position: test_position)
        expect(io.current_output).to include board_with_token
      end
    end

    context 'when the user tries to place a token in an occupied space' do
      it "prompt the user that it's taken" do
        io = FakeIO.new(stdin: test_position)
        game = create_game(io: io)
        game.begin_player_turn
        expect(io.current_output).to include(/select.*position/i)
      end
      it 'prompt the user to choose another position' do
        io = FakeIO.new(stdin: test_position)
        game = create_game(io: io)
        game.begin_player_turn
        simulate_turn_with_input(game: game, io: io, input: test_position)
        expect(io.current_output).to include(/position.*taken/i)
      end
    end

    context 'when the input is outside of the specified range' do
      let(:bad_input) { '-1' }

      it 'prompt the user to choose another position' do
        io = FakeIO.new(stdin: bad_input)
        game = create_game(io: io)
        game.begin_player_turn
        expect(io.current_output).to include(/invalid position/i,
                                             /select another position/i)
      end

      it 'do not place the token on the board' do
        io = FakeIO.new(stdin: bad_input)
        game = create_game(io: io)

        game.begin_player_turn
        expect(io.current_output).not_to include(/X/)
      end

      it "not end the player's turn until a valid input is entered" do
        io = FakeIO.new(stdin: bad_input)
        game = create_game(io: io)

        simulate_turn_with_input(game: game, io: io, input: '5')
        expect(io.current_output).not_to include(/O/)
      end
    end

    context "when the player's turn ends" do
      it 're-render the board' do
        io = FakeIO.new(stdin: '1')
        game = create_game(io: io)
        game.begin_player_turn
        expected_board = board_output_with(token: 'X', position: '1')
        expect(io.current_output).to include expected_board
      end
    end

    context 'when the board is full' do
      it 'outputs game over' do
        board = Board.new(layout: %w[X O X O O X X X O])
        game = create_game(io: FakeIO.new, board: board)
        game_is_over = game.game_over?
        expect(game_is_over).to be_truthy
      end
    end

  end
end
