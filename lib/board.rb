# frozen_string_literal: true

class Board

  def initialize(dimension:)
    number_of_cells = dimension ** 2
    @dimension = dimension
    @layout = [*1..number_of_cells].map(&:to_s)
    @number_of_columns = @number_of_rows = @dimension
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

  def found_winner_at(winning_combination:, token:)
    winner_found = single_token_at_positions?(positions: winning_combination)
    winner_is_token = @layout[winning_combination[0]] == token

    winner_found && winner_is_token
  end

  private

  def single_token_at_positions?(positions:)
    test_positions = [
      @layout[positions[0]], @layout[positions[1]], @layout[positions[2]]
    ]
    is_single_token_at_positions = test_positions.uniq.length == 1
    is_single_token_at_positions
  end
end
