# frozen_string_literal: true

require_relative '../lib/main_io.rb'
require_relative '../lib/presenter.rb'
require_relative '../lib/user_input.rb'
require_relative '../lib/tictactoe_setup.rb'

io = MainIO.new(input_stream: $stdin, output_stream: $stdout)

tictactoe_configuration = {
  setup: TicTacToeSetup.new(user_input: UserInput.new(io: io)),
  presenter: Presenter.new(io: io)
}

Game.start(tictactoe_configuration)
