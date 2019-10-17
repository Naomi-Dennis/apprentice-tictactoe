# frozen_string_literal: true

class AiEasyPlayer
  attr_accessor :token

  def initialize(token:)
    @token = token
  end

  def position(board:)
    occupied_cells = ->(cell_position) { board.occupied_at(position: cell_position) }
    possible_positions = (1..board.number_of_cells).reject(&occupied_cells)
    generated_position = possible_positions.sample

    { space: generated_position, status: :valid }
  end
end
