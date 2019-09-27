# frozen_string_literal: true

class TicTacToe
  def initialize(io:, board:, presenter:)
    @board = board
    @current_token = 'X'
    @io = io
    @presenter = presenter
  end

  def game_over?(tokens:)
    @board.is_full(tokens: tokens)
  end

  def render_board
    board_output = presenter.show_board(board: @board)
    io.puts board_output
  end

  def place_token(position)
    board.put(token: current_token, position: position)
    switch_turn
  end

  def begin_player_turn
    desired_position = prompt_user_for_input
    input_is_valid = validate(user_input: desired_position, board: @board)
    place_token(desired_position) if input_is_valid
    render_board
  end

  private

  attr_accessor :board, :current_token, :io, :presenter

  def prompt_user_for_input
    presenter.prompt_select_position
    desired_position = io.gets.to_i
    desired_position
  end

  def validate(user_input:, board:)
    presenter.tell_position_invalid unless board.has(position: user_input)
    presenter.tell_position_taken if board.occupied_at(position: user_input)
    presenter.prompt_select_another_position
    board.has(position: user_input) && !board.occupied_at(position: user_input)
  end

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end
end
