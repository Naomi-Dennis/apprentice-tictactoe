#!/usr/bin/ruby
#
require_relative '../lib/tictactoe'

class MainIO
  def initialize(stdin: '', stdout: [])
    @stdin = stdin
    @stdout = stdout
    @accepted_input = [*1..9].map!(&:to_s)
  end

  def output_to_user(string)
    @stdout.puts string
  end

  def prompt_user_for_position
    input = $stdin.gets.chomp
    int_to_return = @accepted_input.include?(input) ? input.to_i - 1 : nil
    int_to_return 
  end
end

class Game
  def self.play(game_logic: )
    until( game_logic.game_over )
      game_logic.cycle_player_turn
    end
  end
end

starting_board = TicTacToe::Board.new(layout: Array.new(9, ' ') )
main_io = MainIO.new(stdin: $stdin, stdout: $stdout)
tic_tac_toe = TicTacToe.new(io: main_io, board: starting_board )


Game.play(game_logic: tic_tac_toe )
