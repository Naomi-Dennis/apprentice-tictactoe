# frozen_string_literal: true

require 'spec_helper'
require 'tictactoe'
require 'board'
require 'presenter'
require 'user_input'
require 'fake_io'

class FakePresenter
  def show_game_over; end
end

describe TicTacToe do
  let(:blank_board_output) { "1|2|3\n------\n4|5|6\n------\n7|8|9\n" }

  def default_board
    Board.new(dimension: 3)
  end

  def create_game
    TicTacToe.new
  end

  def board_output_with(token:, position:)
    blank_board_output.sub(position.to_s, token)
  end

  def simulate_player_turn(board: default_board, game:, io:)
    user_input = UserInput.new(io: io)
    presenter = Presenter.new(io: io)
    game.begin_player_turn(board: board, user_input: user_input, presenter: presenter)
  end

  context 'when a new game is started' do
    it 'the first token will be "X"' do
      io = FakeIO.new
      game = create_game
      board = default_board
      game.place_token(board: board, position: 1)
      expect(board.at(position: 1)).to eql 'X'
    end
  end

  context 'when the user interacts with the board' do
    let(:test_position) { '4' }

    def simulate_turn_with_input(board: default_boad, game:, io:, input:)
      io.input_stream = input
      simulate_player_turn(board: board, game: game, io: io)
    end

    context 'when the user tries to place a token in a free space' do
      it 'adds their token to the board' do
        io = FakeIO.new(input_stream: test_position)
        game = create_game
        board = default_board
        simulate_player_turn(board: board, game: game, io: io)
        expect(board.at(position: test_position.to_i)).to eql 'X'
      end
    end

    context 'when the input is outside of the specified range' do
      let(:bad_input) { '-1' }

      it 'does not place the token on the board' do
        io = FakeIO.new(input_stream: bad_input)
        simulate_player_turn(game: create_game, io: io)
        board = default_board
        all_board_positions = ->(position) { board.at(position: position) }
        current_board_tokens = [*1..9].collect(&all_board_positions)
        expect(current_board_tokens).not_to include('X')
      end

      it "not end the player's turn until a valid input is entered" do
        io = FakeIO.new(input_stream: bad_input)
        game = create_game
        board = default_board
        simulate_turn_with_input(board: board, game: game, io: io, input: '5')
        expect(board.at(position: 5)).to be 'X'
      end
    end
  end
end
