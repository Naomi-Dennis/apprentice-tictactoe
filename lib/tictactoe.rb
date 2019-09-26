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
    board[position] = current_token
    switch_turn
    render_board
  end

  def begin_player_turn
    select_another_position_prompt = 'Select another position to place your token [1 - 9]: '
    desired_position = io.gets.to_i
    io.puts 'Select a position to place your token [1 - 9]: '

    list_of_accepted_inputs = [*1..9]
    if !list_of_accepted_inputs.include? desired_position
      io.puts 'Invalid position'
      io.puts select_another_position_prompt
      render_board
    elsif board[desired_position] == ' '
      place_token(desired_position)
    else
      io.puts 'That position is taken!'
      io.puts select_another_position_prompt
      render_board
    end
  end

  private

  attr_accessor :board, :current_token, :io

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end
end
