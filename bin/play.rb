# frozen_string_literal: true

require_relative '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'
require_relative '../lib/presenter'
require_relative '../lib/game'
require_relative '../lib/user_input'


io = MainIO.new(input_stream: $stdin, output_stream: $stdout)

tictactoe = {
  logic: TicTacToe.new,
  user_input: UserInput.new(io: io),
  presenter: Presenter.new(io: io),
  board: Board.new(layout: [*1..9].map!(&:to_s))
}

Game.new.play(tictactoe)
