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
    Board.new(layout: [*1..9].map(&:to_s))
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
      game.place_token_at(board: board, position: 1)
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

    context "when the player's turn ends" do
      it 're-render the board' do
        io = FakeIO.new(input_stream: '1')
        game = create_game
        board = default_board
        simulate_player_turn(board: board, game: game, io: io)
        expect(board.at(position: 1)).to eql 'X'
      end
    end

    context 'when the board is full' do
      it 'outputs game over' do
        board = Board.new(layout: %w[X O X O O X X X O])
        game = create_game
        game_is_over = game.game_over?(presenter: FakePresenter.new, board: board)
        expect(game_is_over).to be_truthy
      end
    end
  end

  context 'when a single token occupies a winning position' do
    context 'when X is the winning token' do
      it 'outputs Player X wins' do
        x_wins = %w[X X X 3 4 5 6 7 8]
        io = FakeIO.new
        game = create_game(io: io, board: Board.new(layout: x_wins))
        game.game_over?(tokens: %w[X O])
        expect(io.current_output).to include(/Player X Wins/i)
      end
    end

    context 'when O is the winning token' do
      it 'outputs Player O wins' do
        o_wins = %w[0 1 2 3 4 5 O O O]
        io = FakeIO.new
        game = create_game(io: io, board: Board.new(layout: o_wins))
        game.game_over?(tokens: %w[X O])
        expect(io.current_output).to include(/Player O Wins/i)
      end
    end
  end

  context 'when a single token occupies winning position 0 1 2' do
    it 'the game is over' do
      x_wins = %w[X X X 3 4 5 6 7 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 3 4 5' do
    it 'the game is over' do
      x_wins = %w[0 1 2 X X X 6 7 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 6 7 8' do
    it 'the game is over' do
      x_wins = %w[0 1 2 3 4 5 X X X]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 0 3 6' do
    it 'the game is over' do
      x_wins = %w[X 1 2 X 4 5 X 7 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 1 4 7' do
    it 'the game is over' do
      x_wins = %w[0 X 2 3 X 5 6 X 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 2 5 8' do
    it 'the game is over' do
      x_wins = %w[0 1 X 3 4 X 6 7 X]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 0 4 7' do
    it 'the game is over' do
      x_wins = %w[X 1 2 3 X 5 6 X 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end

  context 'when a single token occupies winning position 2 4 6' do
    it 'the game is over' do
      x_wins = %w[0 1 X 3 X 5 X 7 8]
      game = create_game(io: FakeIO.new, board: Board.new(layout: x_wins))
      game_over = game.game_over?(tokens: ['X'])
      expect(game_over).to be_truthy
    end
  end
end
