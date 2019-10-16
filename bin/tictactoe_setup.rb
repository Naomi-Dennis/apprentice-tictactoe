
# frozen_string_literal: true

require_relative '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'
require_relative '../lib/presenter'
require_relative '../lib/game'
require_relative '../lib/user_input'
require_relative '../lib/human_player'

class TicTacToeSetup

  io = MainIO.new(input_stream: $stdin, output_stream: $stdout)
  user_input = UserInput.new(io: io)
  presenter = Presenter.new(io: io)
  player_one = HumanPlayer.new(user_input: user_input, token: 'X')
  player_two = HumanPlayer.new(user_input: user_input, token: 'O')

  CARTRIDGE = {
    logic: TicTacToe.new(players: [player_one, player_two]),
    presenter: presenter,
    board: Board.new(dimension: 3)
  }.freeze
end
