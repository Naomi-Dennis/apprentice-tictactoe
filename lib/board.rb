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

  def put(token:, position:)
    @layout[position - 1] = token
  end

  def has(position:)
    position.positive? && position <= @layout.length
  end

  def occupied_at(position:)
    (@layout.none? { |space| space == position.to_s })
  end
end
