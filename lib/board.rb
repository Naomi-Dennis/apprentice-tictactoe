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
    has(position: position) ? @layout[position - 1] : nil
  end

  def put(token:, position:)
    if has(position: position)
      @layout[position - 1] = token
      return token
    end

    nil
  end

  def has(position:)
    position.positive? && position <= @layout.length
  end

  def occupied_at(position:)
    token_in_space = ->(space) { space === position.to_s }
    has(position: position) && @layout.none?(&token_in_space)
  end
end
