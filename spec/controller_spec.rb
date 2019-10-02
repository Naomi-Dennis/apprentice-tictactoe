require 'spec_helper'
require 'controller'
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

describe Controller do
  let(:view) { Presenter.new(io: FakeIO.new) }

  context 'when the user enters input' do
    context 'when the input is an integer represented as a string' do
      it 'returns an integer' do
        controller = Controller.new(io: FakeIO.new(input_stream: '1'))
        expect(controller.input_position).to be_kind_of Numeric
      end
    end

    context 'when the input is an integer, mixed with non-integers, represented as string' do
      it 'returns -1' do
        test_input = '6+sdjkwladj(%*#&@(!*$)$--'
        controller = Controller.new(io: FakeIO.new(input_stream: test_input))
        expect(controller.input_position).to be -1
      end
    end
  end

  context 'when the given position is outside the confines of the board' do
    it 'returns false' do
      view = Presenter.new(io: FakeIO.new)
      board = FakeBoard.new
      controller = Controller.new(io: FakeIO.new(input_stream: '10'))
      validity = controller.check(position: controller.input_position, board: board, view: view)
      expect(validity).to be false
    end

    it 'outputs invalid position' do
      io = FakeIO.new(input_stream: '10')
      view = Presenter.new(io: io)
      board = FakeBoard.new
      controller = Controller.new(io: io)
      controller.check(position: controller.input_position, board: board, view: view)
      expect(io.current_output).to include(/invalid position/i)
    end

    it 'does not output position taken' do
      io = FakeIO.new(input_stream: 10)
      view = Presenter.new(io: io)
      controller = Controller.new(io: io)
      board = FakeBoard.new(occupied_position: controller.input_position)
      controller.check(position: 10, board: board, view: view)
      expect(io.current_output).not_to include(/position.*taken/i)
    end
  end

  context 'when the given position is within the confines of the board' do
    context 'when the position is not taken' do
      it 'returns true' do
        board = FakeBoard.new
        controller = Controller.new(io: FakeIO.new(input_stream: '2'))
        validity = controller.check(position: controller.input_position, board: board, view: view)
        expect(validity).to be_truthy
      end
    end

    context 'when the position is taken' do
      it 'returns false' do
        io = FakeIO.new(input_stream: '2')
        view = Presenter.new(io: io)
        controller = Controller.new(io: io)
        board = FakeBoard.new(occupied_position: controller.input_position)

        validity = controller.check(position: controller.input_position, board: board, view: view)
        expect(validity).to be_falsey
      end

      it 'outputs position taken' do
        io = FakeIO.new(input_stream: '2')
        view = Presenter.new(io: io)
        controller = Controller.new(io: io)
        board = FakeBoard.new(occupied_position: controller.input_position)
        controller.check(position: controller.input_position, board: board, view: view)
        expect(io.current_output).to include(/position.*taken/i)
      end

      it 'does not output invalid position' do
        io = FakeIO.new(input_stream: '2')
        view = Presenter.new(io: io)
        controller = Controller.new(io: io)
        board = FakeBoard.new(occupied_position: controller.input_position)
        controller.check(position: 2, board: board, view: view)
        expect(io.current_output).not_to include(/invalid position/i)
      end
    end
  end
end

