# frozen_string_literal: true

class TicTacToe
  def initialize
    @tokens = %w[X O]
    @current_token = tokens[0]
  end

  def game_over?(presenter:, board:)
    board_is_full, winner = board.is_full(tokens: tokens), find_winner(board: board)
    winner_found = !winner.nil?
    presenter.show_game_over if board_is_full || winner_found
    presenter.show_winner_is(token: winner) if winner_found
    presenter.show_tie_game if board_is_full && !winner_found
    board_is_full || winner_found
  end

  def place_token(position:, board:)
    board.put(token: current_token, position: position)
    switch_turn
  end

  def begin_player_turn(board:, presenter:, user_input:)
    position = prompt_user_for_input(user_input: user_input, presenter: presenter)
    input_is_valid = user_input.check(position: position, board: board, view: presenter)
    place_token(position: position, board: board) if input_is_valid
    presenter.prompt_select_another_position unless input_is_valid
  end

  private

  attr_accessor :board, :current_token, :tokens


  def find_winner(board:)
    winning_token = ->(tok) { board.in_winning_position?(token: tok) }
    winner = tokens.select(&winning_token)
    more_than_one_winner = winner.length > 1
    no_winners_found = winner.empty?
    no_winners_found || more_than_one_winner ? nil : winner.first
  end

  def prompt_user_for_input(presenter:, user_input:)
    presenter.show_player_turn(player: current_token)
    presenter.prompt_select_position
    desired_position = user_input.input_position
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
