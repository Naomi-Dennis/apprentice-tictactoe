# frozen_string_literal: true

require 'spec_helper'
require 'board'

describe Board do
  let(:three_by_three) { [*1..9].map(&:to_s) }

  it 'determine what is in a space' do
    board = Board.new(layout: three_by_three)
    test_position = 1
    empty_space = three_by_three[test_position - 1]
    expect(board.at(position: test_position)).to eql empty_space
  end

  context 'when retrieving a token in a space' do
    context 'when the given position is within the confines of the board' do
      it "returns what's in the space" do
        board = Board.new(layout: three_by_three)
        test_position = 1
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to be 'X'
      end
    end

    context 'when the given position is outside the confines of the board' do
      it 'returns a nil value' do
        board = Board.new(layout: three_by_three)
        test_position = -1
        expect(board.at(position: test_position)).to be_nil
      end
    end
  end

  context "when the board checks if it's full" do
    context 'when the board has available spaces left' do
      it '#is_full is false' do
        board = Board.new(layout: three_by_three)
        test_tokens = %w[X Z]
        expect(board.is_full(tokens: test_tokens)).to be_falsey
      end
    end

    context 'when the board does not have available space left' do
      it '#is_full is true' do
        board = Board.new(layout: Array.new(9, 'X'))
        test_tokens = %w[X Z]
        expect(board.is_full(tokens: test_tokens)).to be_truthy
      end
    end
  end

  context 'when the board is assigning a token a position' do
    context 'when the position is within the confines of the board' do
      it 'returns the placed token as a string' do
        board = Board.new(layout: three_by_three)
        test_position = 1
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to eql 'X'
      end
    end
    context 'when the position is outside the confines of the board' do
      it 'returns nil' do
        board = Board.new(layout: three_by_three)
        test_position = 20
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to be_nil
      end
    end
  end

  context 'when the board checks if a position is within the confines of the board' do
    it 'returns false if the position is not within the confines of the board' do
      board = Board.new(layout: three_by_three)
      position_over_limit =  three_by_three.length + 20
      result = board.has(position: position_over_limit)
      expect(result).to be_falsey
    end

    it 'returns true if the position is within the confines of the board' do
      board = Board.new(layout: three_by_three)
      position_within_limit = 1
      result = board.has(position: position_within_limit)
      expect(result).to be_truthy
    end
  end

  context 'when the board checks if a position is already occupied' do
    it 'returns true if the position is occupied by a token' do
      board = Board.new(layout: three_by_three)
      test_position = 3
      board.put(token: 'X', position: test_position)
      expect(board.occupied_at(position: test_position)).to be true
    end

    it 'returns false if the position is not occupied by a token' do
      board = Board.new(layout: three_by_three)
      test_position = 3
      board.put(token: 'X', position: 4)
      expect(board.occupied_at(position: test_position)).to be false
    end
  end

  it 'returns false if the position is outside the confines of the board' do
      board = Board.new(layout: three_by_three)
      test_position = 10
      board.put(token: 'X', position: 4)
      expect(board.occupied_at(position: test_position)).to be false
  end
end
