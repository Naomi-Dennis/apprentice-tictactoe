# frozen_string_literal: true

class TicTacToe
  def initialize
    @tokens = %w[X O]
    @current_token = tokens[0]
  end

  def game_over?(presenter:, board:)
    game_is_over = board.is_full(tokens: tokens)
    presenter.show_game_over if game_is_over
    game_is_over
  end

  def place_token_at(position:, board:)
    board.put(token: current_token, position: position)
    switch_turn
  end

  def begin_player_turn(board:, presenter:, controller:)
    position = prompt_user_for_input(controller: controller, presenter: presenter)
    input_is_valid = controller.check(position: position, board: board, view: presenter)
    place_token_at(position: position, board: board) if input_is_valid
    presenter.prompt_select_another_position unless input_is_valid
  end

  private

  attr_accessor :board, :current_token, :tokens

  def prompt_user_for_input
    presenter.show_player_turn(player: current_token)
    presenter.prompt_select_position
    desired_position = io.gets.to_i
    desired_position
  end

  def switch_turn
    if @current_token == 'X'
      @current_token = 'O'
    elsif @current_token == 'O'
      @current_token = 'X'
    end
  end
end
