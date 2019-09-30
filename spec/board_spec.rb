# frozen_string_literal: true

require 'spec_helper'
require 'board'

describe Board do
  let(:three_by_three) { [*1..9].map(&:to_s) }

  it 'determine what is in a space' do
    board = Board.new(layout: three_by_three)
    test_position = 1
    empty_space = three_by_three[test_position - 1 ]
    expect(board.at(position: test_position)).to eql empty_space
  end

  it 'determine if the board has any available spaces left' do
    board = Board.new(layout: three_by_three)
    test_tokens = %w[X Z]
    expect(board.is_full(tokens: test_tokens)).to be_falsey
  end

  it 'return all tokens in a given row' do
    board = Board.new(layout: three_by_three)
    row_two_tokens = board.spaces_at(row: 2)
    row_two = three_by_three[3..5]
    expect(row_two_tokens).to eql row_two
  end

  it 'places a token' do
    board = Board.new(layout: three_by_three)
    test_position = 2
    board.put(token: 'X', position: test_position)
    expect(board.at(position: test_position)).to eql 'X'
  end

  context 'detects if the position is within the confines of the board' do
    it 'returns false if the position is within the confines of the board' do
      board = Board.new(layout: three_by_three)
      position_over_limit =  three_by_three.length + 20
      result = board.has(position: position_over_limit)
      expect(result).to be_falsey
    end
  end

end
