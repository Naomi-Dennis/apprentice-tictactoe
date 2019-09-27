# frozen_string_literal: true

require 'spec_helper'
require 'game'

class FakeLogic
  attr_accessor :game_over_called

  def initialize(game_over_loops:)
    @game_over_called = 0
    @game_over_loops = game_over_loops
  end

  def game_over?
    @game_over_called += 1
    @game_over_loops.shift
  end

  def begin_player_turn; end

  def setup; end
end

describe Game do
  it 'loops through game logic until the game is over' do
    game_loops = [false, false, false, false, false, true]
    game = FakeLogic.new(game_over_loops: game_loops)
    Game.play(game_logic: game)
    expect(game.game_over_called).to be 6
  end
end
