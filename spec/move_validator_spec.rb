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

describe MoveValidator do
  let(:view) { Presenter.new(io: FakeIO.new) }

  context 'when the given position is outside the confines of the board' do
    it 'returns false' do
      view = Presenter.new(io: FakeIO.new)
      board = FakeBoard.new
      validity = MoveValidator.check(position: 10, board: board, view: view)
      expect(validity).to be_falsey
    end

    it 'outputs invalid position' do
      io = FakeIO.new
      view = Presenter.new(io: io)
      board = FakeBoard.new
      MoveValidator.check(position: 10, board: board, view: view)
      expect(io.current_output).to include(/invalid position/i)
    end
  end

  context 'when the given position is within the confines of the board' do
    context 'when the position is not taken' do
      it 'returns true' do
        board = FakeBoard.new
        validity = MoveValidator.check(position: 2, board: board, view: view)
        expect(validity).to be_truthy
      end
    end

    context 'when the position is taken' do
      it 'returns false' do
        board = FakeBoard.new(occupied_position: 2)
        validity = MoveValidator.check(position: 2, board: board, view: view)
        expect(validity).to be_falsey
      end

      it 'outputs position taken' do
        io = FakeIO.new
        view = Presenter.new(io: io)
        board = FakeBoard.new(occupied_position: 2)
        MoveValidator.check(position: 2, board: board, view: view)
        expect(io.current_output).to include(/position.*taken/i)
      end
    end
  end
end
