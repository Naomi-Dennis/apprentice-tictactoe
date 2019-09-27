# frozen_string_literal: true

require_relative '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'
require_relative '../lib/presenter'
require_relative '../lib/move_validator'
require_relative '../lib/game'

board = Board.new(layout: [*1..9].map!(&:to_s))
main_io = MainIO.new(stdin: $stdin, stdout: $stdout)
view = Presenter.new(io: main_io)
game_logic = TicTacToe.new(io: main_io, board: board, presenter: view, move_validator: MoveValidator)

Game.play(game_logic: game_logic)
