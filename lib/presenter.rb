class Presenter
  def initialize(io:)
    @io = io
  end

  def prompt_select_position
    io.puts 'Select a position to place your token [1 - 9]:'
  end

  def prompt_select_another_position
    io.puts 'Select another position to place your token [1 - 9]:'
  end

  def tell_position_invalid
    io.puts 'Invalid position!'
  end

end
