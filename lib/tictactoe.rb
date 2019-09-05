# frozen_string_literal: true

class TicTacToe
  def initialize(io:)
    @board = Array.new(9, ' ')
    @current_token = 'X'
    @io = io
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
    render_board
  end

  def current_player
    @current_token
  end

  def cycle_player_turn
    begin_player_turn
    end_player_turn
    render_board
  end

  private

  def begin_player_turn
    desired_position = io.gets.to_i
    io.puts 'Select a position to place your token [1 - 9]: '

    if board[desired_position] == ' '
      place_token(desired_position)
    else
      io.puts 'That position is taken!'
     end
  end

  def end_player_turn
    self.current_token = 'O'
  end

  attr_accessor :board, :current_token, :io
end
