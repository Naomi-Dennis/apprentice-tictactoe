# frozen_string_literal: true

class Game
  def self.play(logic:, board:, presenter:)
    until logic.game_over?(presenter: presenter, board: board)
      presenter.show_board(board: board)
      presenter.show_player_turn(player: logic.current_player_token)
      presenter.prompt_select_position
      player_error_messages = logic.begin_player_turn(board: board)

      display_player_error_messages(presenter: presenter,
                                    messages: player_error_messages)
    end

    presenter.show_board(board: board)
  end

  def self.display_player_error_messages(presenter:, messages:)
    until messages.empty?
      current_message = messages.shift
      presenter.show_player_error_message(message: current_message)
    end
  end

  def self.start(setup:, presenter:)
    menu = setup.create_game_mode_menu
    presenter.show_numbered_menu(menu: menu)
    game_mode_selected = menu.accept_user_selection
    game_mode = setup.build(mode: game_mode_selected, presenter: presenter)
    play(game_mode)
  end

end
