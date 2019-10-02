# frozen_string_literal: true

class Game
  def self.play(logic:, controller:, board:, presenter:)
    until logic.game_over?(presenter: presenter, board: board)
      presenter.show_board(board: board)
      logic.begin_player_turn(board: board, controller: controller, presenter: presenter)
    end
  end
end
