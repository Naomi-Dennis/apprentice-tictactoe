# frozen_string_literal: true

require 'spec_helper'
require 'tictactoe'
require 'board'
require 'presenter'
require 'user_input'
require 'fake_io'
require 'human_player'

class FakePresenter
  def show_game_over; end
  def show_winner_is(token:); end
end

describe TicTacToe do
  let(:blank_board_output) { "1|2|3\n------\n4|5|6\n------\n7|8|9\n" }

  def default_board
    Board.new(dimension: 3)
  end

  def human_player(token:, position: 0)
    io = FakeIO.new(input_stream: position.to_s)
    HumanPlayer.new(user_input: UserInput.new(io: io),
                              token: token)
  end

  def create_game(players: [human_player(token: 'X'), human_player(token: 'O')])
    players = players
    TicTacToe.new(players: players)
  end

  def board_output_with(token:, position:)
    blank_board_output.sub(position.to_s, token)
  end

  def simulate_player_turn(board: default_board, game:, io:)
    user_input = UserInput.new(io: io)
    presenter = Presenter.new(io: io)
    game.begin_player_turn(board: board)
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
        player_x = human_player(token: 'X', position: test_position)
        game = create_game(players: [player_x])
        board = default_board
        simulate_player_turn(board: board, game: game, io: FakeIO.new)
        expect(board.at(position: test_position.to_i)).to eql 'X'
      end


      it 'returns an empty error messages list' do
        player_x = human_player(token: 'X', position: test_position)
        game = create_game(players: [player_x])
        board = default_board
        error_messages = simulate_player_turn(board: board, game: game, io: FakeIO.new)
        expect(error_messages).to be_empty
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
        game = create_game(players: [human_player(token: 'X', position: 5),
                                     human_player(token: 'O', position: 4)])
        board = default_board
        simulate_player_turn(board: board, game: game, io: FakeIO.new)
        expect(board.at(position: 5)).to be 'X'
      end

      it 'returns a list of error messages including invalid position symbol' do
        game = create_game(players: [human_player(token: 'X', position: 11),
                                     human_player(token: 'O', position: 4)])
        board = default_board
        errors = simulate_player_turn(board: board, game: game, io: FakeIO.new)
        expect(errors).to include Presenter::POSITION_INVALID
      end

      it 'returns a list of error messages including select another position symbol' do
        game = create_game(players: [human_player(token: 'X', position: 11),
                                     human_player(token: 'O', position: 4)])
        board = default_board
        errors = simulate_player_turn(board: board, game: game, io: FakeIO.new)
        expect(errors).to include Presenter::SELECT_ANOTHER_POSITION
      end
    end
  end

  describe '#game_over?' do
    def put_token_in_positions(token:, positions:, board:)
      place_token = ->(token_position) { board.put(token: token, position: token_position) }
      positions.each(&place_token)
    end

    context 'when the board is full' do
      it 'returns true' do
          test_board, game = default_board, create_game
          put_token_in_positions(token: 'X', board: test_board, positions: [1,2,4,6,8])
          put_token_in_positions(token: 'O', board: test_board, positions: [3,5,7,9])
          game_over = game.game_over?(presenter: FakePresenter.new, board: test_board)
          expect(game_over).to be true
      end
    end

    context 'when the game is won' do
      context 'when X wins' do
      it 'returns true' do
        test_board, game = default_board, create_game
        put_token_in_positions(token: 'X', board: test_board, positions: [1,2,3])
        put_token_in_positions(token: 'O', board: test_board, positions: [4,5,7,9])
        game_over = game.game_over?(presenter: FakePresenter.new, board: test_board)
        expect(game_over).to be true
      end
    end
    end

    context "when the board isn't full and no winner is found" do
      it 'returns false' do
        test_board, game = default_board, create_game
        put_token_in_positions(token: 'X', board: test_board, positions: [1,2])
        put_token_in_positions(token: 'O', board: test_board, positions: [3,5,6])
        game_over = game.game_over?(presenter: FakePresenter.new, board: test_board)
        expect(game_over).to be false
      end
    end
  end

  it 'returns the token of the current player' do
    current_player_token = create_game.current_player_token
    expect(current_player_token).to eql 'X'
  end
end
