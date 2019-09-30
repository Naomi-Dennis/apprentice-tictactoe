require_relative  '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'

board = Board.new(layout: [*1..9].map!(&:to_s))
main_io = MainIO.new(stdin: $stdin, stdout: $stdout)
game = TicTacToe.new(io: main_io, board: board)
game.render_board
game.begin_player_turn
