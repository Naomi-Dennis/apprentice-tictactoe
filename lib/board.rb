# frozen_string_literal: true

class Board
  def initialize(layout:)
    @layout = layout
  end

  def is_full(tokens:)
    cells_equal_to_a_token = ->(cell) { tokens.include?(cell) }
    @layout.all?(&cells_equal_to_a_token)
  end

end
