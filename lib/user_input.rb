class UserInput
  def initialize(io:)
    @io = io
  end

  def input_position
    input = @io.get_keyboard_input
    return -1 unless input.match?(/^\d*$/)

    input = input.to_i
    input
  end

  def check(position:, board:)
    position_validity = :valid
    position_validity = Presenter::POSITION_TAKEN if board.occupied_at(position: position)
    position_validity = Presenter::POSITION_INVALID unless board.has(position: position)
    final_position = position if position_validity == :valid

    { status: position_validity, space: final_position }
  end
end
