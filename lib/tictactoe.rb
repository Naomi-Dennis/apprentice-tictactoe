# frozen_string_literal: true

class TicTacToe
  def initialize(players:)
    @players = players
    @current_player = players.first
  end

  def game_over?(presenter:, board:)
    tokens = players.collect { |player| player.token }
    board_is_full, winner = board.is_full(tokens: tokens), find_winner(board: board)
    winner_found = !winner.nil?
    presenter.show_game_over if board_is_full || winner_found
    presenter.show_winner_is(token: current_player_token) if winner_found
    presenter.show_tie_game if board_is_full && !winner_found
    board_is_full || winner_found
  end

  def place_token(position:, board:)
    board.put(token: current_player_token, position: position)
    switch_turn
  end

  def begin_player_turn(board:)
    player_error_messages = []
    chosen_position = current_player.position(board: board)
    position_invalid = chosen_position[:space].nil?
    place_token(position: chosen_position[:space], board: board) unless position_invalid

    player_error_messages << chosen_position[:status] if position_invalid
    player_error_messages << Presenter::SELECT_ANOTHER_POSITION if position_invalid
    player_error_messages
  end

  def current_player_token
    current_player.token
  end 

  private

  attr_accessor :board, :current_token, :current_player, :players


  def find_winner(board:)
    winner = ->(player) { board.in_winning_position?(token: player.token) }
    winner = players.select(&winner)
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
    if current_player == players.first
      @current_player = players.last
    elsif current_player == players.last
      @current_player = players.first
    end
  end
end
