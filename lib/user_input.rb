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

  def check(position:, board:, view:)
    view.tell_position_taken if board.occupied_at(position: position)
    view.tell_position_invalid unless board.has(position: position)
    board.has(position: position) && !board.occupied_at(position: position)
  end
end
