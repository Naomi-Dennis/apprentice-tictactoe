class Presenter
  def initialize(io:)
    @io = io
  end

  def prompt_select_position
    io.puts 'Select a position to place your token [1 - 9]:'
  end

end
