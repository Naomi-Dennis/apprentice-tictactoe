# frozen_string_literal: true

class HumanPlayer
  attr_reader :token

  def initialize(token:, user_input:)
    @token = token
    @user_input = user_input
  end

  def position(board:)
    chosen_position = @user_input.input_position
    position_validity = @user_input.check(position: chosen_position,
                                          board: board)
    position_validity
  end

  private

  attr_accessor :user_input
end
