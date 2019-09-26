# frozen_string_literal: true

class TicTacToe
  def initialize(io: , board:)
    @board = board
    @current_token = 'X'
    @io = io
  end

  def render_board
    board_output = <<~BOARD_RENDER
      #{@board.at(position: 1)}|#{@board.at(position: 2)}|#{@board.at(position: 3)}
      ------
      #{@board.at(position: 4)}|#{@board.at(position: 5)}|#{@board.at(position: 6)}
      ------
      #{@board.at(position: 7)}|#{@board.at(position: 8)}|#{@board.at(position: 9)}
    BOARD_RENDER
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

  attr_accessor :board, :current_token, :io

  def prompt_user_for_input
    prompt_select_position
    desired_position = io.gets.to_i
    desired_position
  end

  def validate(user_input:, board:)
    tell_user_position_is_invalid unless board.has(position: user_input)
    tell_user_position_is_taken if board.occupied_at(position: user_input)
    ask_user_select_another_position
    board.has(position: user_input) && !board.occupied_at(position: user_input)
  end

  def ask_user_select_another_position
    io.puts 'Select another position to place your token [1 - 9]:'
  end

  def prompt_select_position
    io.puts 'Select a position to place your token [1 - 9]: '
  end

  def tell_user_position_is_invalid
    io.puts 'Invalid position'
  end

  def tell_user_position_is_taken
    io.puts 'That position is taken!'
  end

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end
end
