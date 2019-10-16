require 'spec_helper'
require 'user_input'
require 'presenter'
require 'fake_io'

class FakeBoard
  def initialize(occupied_position: -1)
    @layout = [*1..9]
    @occupied_position = occupied_position
  end

  def has(position:)
    not_too_low = position >= @layout[0]
    not_too_high = position <= @layout[layout.length - 1]
    not_too_low && not_too_high
  end

  def occupied_at(position:)
    @occupied_position == position && has(position: position)
  end

  private

  attr_accessor :layout
end

describe UserInput do
  let(:view) { Presenter.new(io: FakeIO.new) }

  describe '#input_position' do
    context 'when the input is an integer represented as a string' do
      it 'returns an integer' do
        controller = UserInput.new(io: FakeIO.new(input_stream: '1'))
        expect(controller.input_position).to be_kind_of Numeric
      end
    end

    context 'when the input is an integer, mixed with non-integers, represented as string' do
      it 'returns -1' do
        test_input = '6+sdjkwladj(%*#&@(!*$)$--'
        controller = UserInput.new(io: FakeIO.new(input_stream: test_input))
        expect(controller.input_position).to be -1
      end
    end
  end

  describe '#check' do
    it 'returns a hash' do
      board = FakeBoard.new
      controller = UserInput.new(io: FakeIO.new(input_stream: '2'))
      validity = controller.check(position: controller.input_position, board: board)
      expect(validity).to be_kind_of Hash
    end

    it 'returned hash status attribute is a symbol' do
      board = FakeBoard.new
      controller = UserInput.new(io: FakeIO.new(input_stream: '2'))
      validity = controller.check(position: controller.input_position, board: board)
      expect(validity[:status]).to be_kind_of Symbol
    end

    context 'when given position is a valid position on the board' do
      it 'returned hash status attribute is :valid' do
        board = FakeBoard.new
        controller = UserInput.new(io: FakeIO.new(input_stream: '2'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:status]).to be :valid
      end

      it 'returned hash space attribute is an Integer' do
        board = FakeBoard.new
        controller = UserInput.new(io: FakeIO.new(input_stream: '2'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:space]).to be_kind_of Integer
      end
    end

    context 'when the given position is not on the board (assume 3x3)' do
      it 'returned hash status attribute is not :valid' do
        board = FakeBoard.new
        controller = UserInput.new(io: FakeIO.new(input_stream: '1112'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:status]).not_to be :valid
      end

      it 'returned hash space attribute is nil' do
        board = FakeBoard.new
        controller = UserInput.new(io: FakeIO.new(input_stream: '1112'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:space]).to be_kind_of NilClass
      end
    end

    context 'when the given position is already occupied' do
      it 'returned hash status attribute is not :valid' do
        board = FakeBoard.new(occupied_position: 1)
        controller = UserInput.new(io: FakeIO.new(input_stream: '1'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:status]).not_to be :valid
      end

      it 'returned hash space attribute is nil' do
        board = FakeBoard.new(occupied_position: 1)
        controller = UserInput.new(io: FakeIO.new(input_stream: '1'))
        validity = controller.check(position: controller.input_position, board: board)
        expect(validity[:space]).to be_kind_of NilClass
      end
    end
  end
end
