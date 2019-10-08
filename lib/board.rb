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

  def in_winning_position?(token:)
    occupied_by_token = ->(space) { space == token }

    right_diagonal_positions.all?(&occupied_by_token) ||
    left_diagonal_positions.all?(&occupied_by_token) ||
    list_of_rows.any? { |row| row.all?(&occupied_by_token) } ||
    list_of_columns.any? { |column| column.all?(&occupied_by_token) }
  end

  private

  attr_accessor :dimension, :layout, :number_of_columns, :number_of_rows

  def list_of_columns
    (1..number_of_columns).collect do |column|
      select_column(column: column)
    end
  end

  def list_of_rows
    (1..number_of_rows).collect do |row|
      select_row(row: row)
    end
  end

  def select_row(row:)
    row_position = 1 + ((row - 1) * dimension)
    distance_between_positions = 1
    tokens_at_nth_positions(n: distance_between_positions, starting_position: row_position)
  end

  def select_column(column:)
    column_position = column
    distance_between_positions = dimension
    tokens_at_nth_positions(n: distance_between_positions, starting_position: column_position)
  end

  def right_diagonal_positions
    top_right_position = dimension
    distance_between_positions = dimension - 1
    tokens_at_nth_positions(n: distance_between_positions, starting_position: top_right_position)
  end

  def left_diagonal_positions
    top_left_position = 1
    distance_between_positions = dimension + 1
    tokens_at_nth_positions(n: distance_between_positions, starting_position: top_left_position)
  end

  def tokens_at_nth_positions(starting_position:, n:)
    spaces_at_nth_positions = (starting_position..number_of_cells).step(n).to_a

    number_of_tokens_in_set = dimension - 1
    nth_positions_within_set = spaces_at_nth_positions[0..number_of_tokens_in_set]
    tokens_at_positions_within_set = ->(position_within_set) { at(position: position_within_set) }

    nth_positions_within_set.collect(&tokens_at_positions_within_set)
  end

  def number_of_cells
    dimension**2
  end
end
