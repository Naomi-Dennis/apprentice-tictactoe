# frozen_string_literal: true

require_relative '../lib/tictactoe'
require_relative '../lib/main_io'
require_relative '../lib/board'
require_relative '../lib/presenter'
require_relative '../lib/game'
require_relative '../lib/user_input'
require_relative '../lib/human_player'
require_relative '../lib/ai_easy_player'
require_relative '../lib/menu'


class TicTacToeSetup
  def initialize(user_input:)
    @user_input = user_input
  end

  def create_game_mode_menu
    menu = Menu.new(user_input: user_input)
    menu.add_option(option: 'human vs. human')
    menu.add_option(option: 'human vs. computer')

    menu
  end

  def build(mode:, presenter:)
    players = create_two_human_players if mode == 'human vs. human'
    players = create_human_and_computer_player if mode == 'human vs. computer'
    logic = TicTacToe.new(players: players)

    { presenter: presenter, board: Board.new(dimension: 3), logic: logic }
  end


  private

  attr_accessor :presenter, :user_input

  def create_two_human_players
    player_one = HumanPlayer.new(user_input: user_input, token: 'X')
    player_two = HumanPlayer.new(user_input: user_input, token: 'O')

    [player_one, player_two]
  end

  def create_human_and_computer_player
    player_one = HumanPlayer.new(user_input: user_input, token: 'X')
    player_two = AiEasyPlayer.new(token: 'O')

    [player_one, player_two]
  end
end
