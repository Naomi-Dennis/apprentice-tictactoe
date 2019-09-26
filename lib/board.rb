# frozen_string_literal: true

class Board
  def initialize(layout:)
    @layout = layout
  end

  def is_full(tokens:)
    cells_equal_to_a_token = ->(cell) { tokens.include?(cell) }
    @layout.all?(&cells_equal_to_a_token)
  end

  def at(position:)
    @layout[position - 1]
  end

  def spaces_at(row:)
    number_of_columns_in_row = Math.sqrt(@layout.length)
    starting_index = number_of_columns_in_row * (row - 1)
    ending_index = starting_index + (number_of_columns_in_row - 1)
    requested_row = @layout[starting_index..ending_index]
    requested_row
  end

end
