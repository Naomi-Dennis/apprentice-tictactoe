# frozen_string_literal: true

class TicTacToe
  def initialize(io:)
    @board = Array.new(9, ' ')
    @current_token = 'X'
    @io = io
    @move_valid = false
  end

  def render_board
    io.puts "#{@board[0]}|#{@board[1]}|#{@board[2]}"
    io.puts '------'
    io.puts "#{@board[3]}|#{@board[4]}|#{@board[5]}"
    io.puts '------'
    io.puts "#{@board[6]}|#{@board[7]}|#{@board[8]}"
    board
  end

  def place_token(position)
    board[position] = current_token
    switch_turn
    render_board
  end

  def current_player
    current_token
  end

  def begin_player_turn
    select_another_position_prompt = 'Select another position to place your token [1 - 9]: '
    desired_position = io.gets.to_i
    io.puts 'Select a position to place your token [1 - 9]: '

    if ![*1..9].include? desired_position
      io.puts 'Invalid position'
      io.puts select_another_position_prompt
      render_board
    elsif board[desired_position] == ' '
      @move_valid = true
      place_token(desired_position)
    else
      io.puts 'That position is taken!'
      io.puts select_another_position_prompt
      render_board
     end
  end

  private

  attr_accessor :board, :current_token, :io, :move_valid

  def switch_turn
    if @move_valid
      if @current_token == 'X'
        @current_token = 'O'
      elsif @current_token == 'O'
        @current_token = 'X'
      end
      @move_valid = false
    end
  end
end
