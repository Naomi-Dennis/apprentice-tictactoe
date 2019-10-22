# frozen_string_literal: true

class Presenter

  POSITION_TAKEN = :position_taken
  POSITION_INVALID = :invalid_position
  SELECT_ANOTHER_POSITION = :select_another_position

  def initialize(io:)
    @io = io
  end

  def prompt_select_position
    io.output_to_screen 'Select a position to place your token [1 - 9]:'
  end

  def prompt_select_another_position
    io.output_to_screen 'Select another position to place your token [1 - 9]:'
  end

  def tell_position_invalid
    io.output_to_screen 'Invalid position!'
  end

  def tell_position_taken
    io.output_to_screen 'That position is taken!'
  end

  def show_board(board:)
    io.output_to_screen  <<~BOARD_RENDER
      #{board.at(position: 1)}|#{board.at(position: 2)}|#{board.at(position: 3)}
      ------
      #{board.at(position: 4)}|#{board.at(position: 5)}|#{board.at(position: 6)}
      ------
      #{board.at(position: 7)}|#{board.at(position: 8)}|#{board.at(position: 9)}
    BOARD_RENDER
  end

  def show_player_turn(player:)
    io.output_to_screen "---------- Player #{player} Turn ----------"
  end

  def show_winner_is(token:)
    io.output_to_screen "-------- Player #{token} Won ------"
  end

  def show_game_over
    io.output_to_screen '--------- Game Over --------'
  end

  def show_tie_game
    io.output_to_screen '--------- Tie Game --------'
  end

  def show_player_error_message(message:)
    case message
    when POSITION_TAKEN
      tell_position_taken
    when POSITION_INVALID
      tell_position_invalid
    when SELECT_ANOTHER_POSITION
      prompt_select_another_position
    end
  end

  def show_numbered_menu(menu:)
    selection = 1
    until (current_option = menu.option_at(position: selection)).nil?
      io.output_to_screen "#{selection}. #{current_option}"
      selection += 1
    end
  end

  private

  attr_accessor :io
end
