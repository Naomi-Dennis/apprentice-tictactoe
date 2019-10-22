# frozen_string_literal: true

class Menu
  def initialize(user_input:)
    @options = []
    @user_input = user_input
  end

  def add_option(option:)
    options << option
  end

  def accept_user_selection
    selection = user_input.input_position
    options[selection - 1]
  end

  def option_at(position:)
    return @options[position - 1] if position <= @options.length
    return nil if position > @options.length
  end

  private

  attr_accessor :options, :user_input
end
