# frozen_string_literal: true

class TicTacToe
  def initialize(io:, board:)
    @board = board
    @current_token = 'X'
    @io = io
  end

  def render_board
    board_output = <<~BOARD_RENDER
    #{@board.get_info_at_position(position: 0)}|#{@board.get_info_at_position(position: 1)}|#{@board.get_info_at_position(position: 2)}
    ------
    #{@board.get_info_at_position(position: 3)}|#{@board.get_info_at_position(position: 4)}|#{@board.get_info_at_position(position: 5)}
    ------
    #{@board.get_info_at_position(position: 6)}|#{@board.get_info_at_position(position: 7)}|#{@board.get_info_at_position(position: 8)}
    BOARD_RENDER
    io.output_to_user board_output
    board_output
  end

  def cycle_player_turn
    io.output_to_user "----------------- Player #{current_token} Turn -------------"
    io.output_to_user 'Select a position to place your token [1 - 9]: '

    select_another_position_prompt = 'Select another position to place your token [1 - 9]: '
    desired_position = io.prompt_user_for_position

    input_is_not_valid = desired_position.nil?
    if input_is_not_valid
      io.output_to_user 'Invalid position'
      io.output_to_user select_another_position_prompt
    elsif !position_is_free(desired_position)
      io.output_to_user 'That position is taken!'
      io.output_to_user select_another_position_prompt
    else
      place_token(desired_position)
      end_player_turn
    end

    render_board
  end

  private

  attr_accessor :board, :current_token, :io

  def position_is_free(position)
    empty_position_label = (position + 1).to_s
    board.get_info_at_position(position: position) == empty_position_label
  end

  def place_token(position)
    board.assign_token_to_position(position: position, token: current_token)
  end

  def end_player_turn
    switch_turn
  end

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end

  class Board
    def initialize(layout: )
      @layout = layout
    end

    def assign_token_to_position(position:, token:)
      @layout[position.to_i] = token
    end

    def get_info_at_position(position: )
      @layout[position.to_i]
    end

  end
end
