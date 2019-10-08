# frozen_string_literal: true

class Game
  def self.play(logic:, user_input:, board:, presenter:)
    until logic.game_over?(presenter: presenter, board: board)
      presenter.show_board(board: board)
      logic.begin_player_turn(board: board, user_input: user_input, presenter: presenter)
    end
    presenter.show_board(board: board)
  end
end
