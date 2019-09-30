# frozen_string_literal: true

class TicTacToe
  def initialize
    @tokens = %w[X O]
    @current_token = tokens[0]
  end

  def game_over?(presenter:, board:)
    board_is_full = board.is_full(tokens: tokens)
    winner = tokens.find { |token| is_winner?(board:board, player: token) }
    winner_found = !winner.nil?
    board_is_full || winner_found
  end

  def place_token(position:, board:)

    board.put(token: current_token, position: position)
    switch_turn
  end

  def begin_player_turn(board:, presenter:, user_input:)
    position = prompt_user_for_input(user_input: user_input, presenter: presenter)
    input_is_valid = user_input.check(position: position, board: board, view: presenter)
    place_token(position: position, board: board) if input_is_valid
    presenter.prompt_select_another_position unless input_is_valid
  end

  private

  attr_accessor :board, :current_token, :tokens

  def winning_combinations
    [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],

      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],

      [0, 4, 7],
      [2, 4, 6]
    ]
  end

  def prompt_user_for_input
    presenter.prompt_select_position
    desired_position = user_input.input_position
    desired_position
  end

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end
end
