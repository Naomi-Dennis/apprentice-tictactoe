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

  def tell_position_taken
    io.puts 'That position is taken!'
  end

  def show_board(board:)
    <<~BOARD_RENDER
      #{board.at(position: 1)}|#{board.at(position: 2)}|#{board.at(position: 3)}
      ------
      #{board.at(position: 4)}|#{board.at(position: 5)}|#{board.at(position: 6)}
      ------
      #{board.at(position: 7)}|#{board.at(position: 8)}|#{board.at(position: 9)}
    BOARD_RENDER
  end

  private

  attr_accessor :io
end

