# frozen_string_literal: true

class MoveValidator
  def self.check(position:, board:, view:)
    view.tell_position_taken if board.occupied_at(position: position)
    view.tell_position_invalid unless board.has(position: position)
    board.has(position: position) && !board.occupied_at(position: position)
  end
end
