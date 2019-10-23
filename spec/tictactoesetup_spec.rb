require 'spec_helper'
require 'tictactoe_setup'
require 'fake_io'

class FakeUserInput
  def initialize(io:)
    @io = io
  end 
end
class FakePresenter; end
class FakeTicTacToeSetup
  attr_reader :create_two_human_players_called,
              :create_human_and_computer_player_called

  def initialize(user_input:)
    @create_two_human_players_called = false
    @create_human_and_computer_player_called = false
  end

  def build(mode:, presenter:)
    @create_two_human_players_called = true if mode == 'human vs. human'
    @create_human_and_computer_player_called = true if mode == 'human vs. computer'
  end

  def create_two_human_players; end

  def create_human_and_computer_player; end
end

class FakeMenu
  attr_accessor :options
  def initialize(user_input:)
    @options = []
  end

  def option_at(position:)
    @options[position - 1]
  end

  def add_option(option:)
    options << option
  end
end

describe TicTacToeSetup do
  context 'when the game menu is created' do
    it 'has a human vs human option' do
      setup = TicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
      menu = setup.create_game_mode_menu
      game_menu_option = menu.option_at(position: 1)
      expect(game_menu_option).to eql 'human vs. human'
    end

    it 'has a human vs computer option' do
      setup = TicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
      menu = setup.create_game_mode_menu
      game_menu_option = menu.option_at(position: 2)
      expect(game_menu_option).to eql 'human vs. computer'
    end
  end

  context 'when the game data is built' do
    it 'returns game data'  do
      setup = TicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
      game_data = setup.build(mode: 'human vs. human',
                              presenter: FakePresenter.new)
      expect(game_data).not_to be_kind_of NilClass
    end

    context 'when the mode is human vs. human' do
      it 'creates a tic tac toe game with two human players' do
        setup = FakeTicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
        setup.build(mode: 'human vs. human', presenter: FakePresenter.new)

        expect(setup.create_two_human_players_called).to be true
      end

      it "doesn't create a tic tac toe game with a human and computer player" do
        setup = FakeTicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
        setup.build(mode: 'human vs. human', presenter: FakePresenter.new)

        expect(setup.create_human_and_computer_player_called).to be false
      end
    end

    context 'when the mode is human vs. computer' do
      it 'creates a tic tac toe game with one human player and one computer player' do
        setup = FakeTicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
        setup.build(mode: 'human vs. computer', presenter: FakePresenter.new)

        expect(setup.create_human_and_computer_player_called).to be true
      end

      it "doesn't create a tic tac toe game with two human players" do
        setup = FakeTicTacToeSetup.new(user_input: FakeUserInput.new(io: FakeIO.new))
        setup.build(mode: 'human vs. computer', presenter: FakePresenter.new)

        expect(setup.create_two_human_players_called).to be false
      end
    end
  end
end
