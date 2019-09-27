# frozen_string_literal: true

class Game
  def self.play(game_logic:)
    game_logic.setup
    game_logic.begin_player_turn until game_logic.game_over?
  end
end
