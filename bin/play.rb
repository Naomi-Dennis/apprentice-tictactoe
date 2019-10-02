# frozen_string_literal: true

require_relative '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'
require_relative '../lib/presenter'
require_relative '../lib/game'
require_relative '../lib/controller'


io = MainIO.new(input_stream: $stdin, output_stream: $stdout)

game_setup = {
  logic: TicTacToe.new,
  controller: Controller.new(io: io),
  presenter: Presenter.new(io: io),
  board: Board.new(layout: [*1..9].map!(&:to_s))
}

Game.play(game_setup)
