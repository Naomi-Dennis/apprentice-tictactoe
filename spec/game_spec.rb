# frozen_string_literal: true

require 'spec_helper'
require 'game'
require 'fake_io'
class FakeLogic
  attr_accessor :game_over_called

  def initialize(game_over_loops:)
    @game_over_called = 0
    @game_over_loops = game_over_loops
  end

  def game_over?(presenter:, board:)
    @game_over_called += 1
    @game_over_loops.shift
  end

  def begin_player_turn(board:, user_input:, presenter:); end

  def setup; end
end

class FakePresenter
  def show_board(board:); end
end

class FakeBoard; end


describe Game do
  it 'loops through game logic until the game is over' do
    game_loops = [false, false, false, false, false, true]
    game = FakeLogic.new(game_over_loops: game_loops)
    Game.play(user_input: FakeIO.new, board: FakeBoard.new, presenter: FakePresenter.new, logic: game)
    expect(game.game_over_called).to be 6
  end
end
