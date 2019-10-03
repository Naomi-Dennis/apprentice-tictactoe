# frozen_string_literal: true

require 'spec_helper'
require 'game'
require 'fake_io'
class FakeTicTacToe
  attr_accessor :game_over_received_true

  def initialize
    @game_over_called = 0
    @game_over_loops = [false, false, false, false, false, true]
    @game_over_received_true = false
  end

  def game_over?(presenter:, board:)
    @game_over_called += 1
    @game_over_received_true = @game_over_loops.shift
    @game_over_received_true
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
    game = FakeTicTacToe.new
    game_data = {
      user_input: FakeIO.new,
      board: FakeBoard.new,
      presenter: FakePresenter.new,
      logic: game
    }
    Game.play(game_data)
    game_ended = game.game_over_received_true
    expect(game_ended).to be true
  end
end
