# frozen_string_literal: true

require 'spec_helper'
require 'presenter'
require 'move_validator'

class FakeBoard
  def initialize(occupied_position: -1)
    @min_input_allowed = 1
    @max_input_allowed = 9
    @occupied_position = occupied_position
  end

  def has(position:)
    not_too_low = position >= @min_input_allowed
    not_too_high = position <= @max_input_allowed
    not_too_low && not_too_high
  end

  def occupied_at(position:)
    @occupied_position == position
  end
end

class FakeIO
  attr_accessor :stdout
  def initialize
    @stdout = []
  end

  def puts(string)
    @stdout << string
    string
  end

  def current_output
    @stdout
  end
end

