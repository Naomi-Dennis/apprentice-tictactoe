# frozen_string_literal: true

require 'spec_helper'
require 'board'

describe Board do
  let(:test_dimension) { 4 }
  let(:number_of_cells) { test_dimension**2 }

  context 'when retrieving a token in a space' do
    context 'when the given position is within the confines of the board' do
      it "returns what's in the space" do
        board = Board.new(dimension: test_dimension)
        test_position = 1
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to be 'X'
      end
    end

    context 'when the given position is outside the confines of the board' do
      it 'returns a nil value' do
        board = Board.new(dimension: test_dimension)
        test_position = -1
        expect(board.at(position: test_position)).to be_nil
      end
    end
  end

  context "when the board checks if it's full" do
    context 'when the board has available spaces left' do
      it '#is_full is false' do
        board = Board.new( dimension: test_dimension)
        test_tokens = %w[X Z]
        expect(board.is_full(tokens: test_tokens)).to be_falsey
      end
    end

    context 'when the board does not have available space left' do
      it '#is_full is true' do
        board = Board.new(dimension: test_dimension)
        test_tokens = %w[X O]
        place_token = ->(position) { board.put(token: test_tokens.sample, position: position)}
        (number_of_cells + 1).times(&place_token)
        expect(board.is_full(tokens: test_tokens)).to be_truthy
      end
    end
  end

  context 'when the board is assigning a token a position' do
    context 'when the position is within the confines of the board' do
      it 'returns the placed token as a string' do
        board = Board.new(dimension: test_dimension)
        test_position = 1
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to eql 'X'
      end
    end

    context 'when the position is outside the confines of the board' do
      it 'returns nil' do
        board = Board.new( dimension: test_dimension)
        test_position = number_of_cells + 1
        board.put(token: 'X', position: test_position)
        expect(board.at(position: test_position)).to be_nil
      end
    end
  end

  describe '#has' do
    context 'when the board checks if a position is within the confines of the board' do
      it 'returns false if the position is not within the confines of the board' do
        board = Board.new(dimension: test_dimension)
        position_over_limit = number_of_cells + 1
        result = board.has(position: position_over_limit)
        expect(result).to be_falsey
      end

      it 'returns true if the position is within the confines of the board' do
        board = Board.new(dimension: test_dimension)
        position_within_limit = 1
        result = board.has(position: position_within_limit)
        expect(result).to be_truthy
      end
    end
  end


  describe '#at' do
    it 'determine what is in a space' do
      board = Board.new( dimension: test_dimension)
      test_position = 1
      empty_space = test_position.to_s
      expect(board.at(position: test_position)).to eql empty_space
    end
  end

  describe '#put' do
    context 'when the board checks if a position is already occupied' do
      it 'returns true if the position is occupied by a token' do
        board = Board.new( dimension: test_dimension)
        test_position = 3
        board.put(token: 'X', position: test_position)
        expect(board.occupied_at(position: test_position)).to be true
      end

      it 'returns false if the position is not occupied by a token' do
        board = Board.new( dimension: test_dimension)
        test_position = 3
        board.put(token: 'X', position: 4)
        expect(board.occupied_at(position: test_position)).to be false
      end
    end

    it 'returns false if the position is outside the confines of the board' do
      board = Board.new( dimension: test_dimension)
      test_position = 10
      board.put(token: 'X', position: 4)
      expect(board.occupied_at(position: test_position)).to be false
    end
  end

  describe '#in_winning_position?' do
    let(:token) { 'X' }
    let(:three_by_three) { 3 }

    context 'when the token occupies all positions along the right diagonal' do
      it 'returns true' do
        board = Board.new(dimension: three_by_three)
        [3,5,7].each { |pos| board.put(token: token, position: pos) }
        x_wins = board.in_winning_position?(token: token)

        expect(x_wins).to be true
      end
    end

    context 'when the token occupies all positions along the left diagonal' do
      it 'returns true' do
        board = Board.new(dimension: three_by_three)
        [1,5,9].each { |pos| board.put(token: token, position: pos) }
        x_wins = board.in_winning_position?(token: token)

        expect(x_wins).to be true
      end
    end

    context 'when a board is 3x3' do
      context 'when a token occupies all positions in the first row'  do
        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [1,2,3].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end

      context 'when a token occupies all positions in the second row' do

        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [4,5,6].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end

      context 'when a token occupies all positions in the third row' do

        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [7,8,9].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end
    end

    context 'when a board is 3x3' do
      context 'when a token occupies all postions in the first column' do
        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [1,4,7].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end

      context 'when a token occupies all postions in the second column' do
        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [2,5,8].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end

      context 'when a token occupies all postions in the third column' do
        it 'returns true' do
          board = Board.new(dimension: three_by_three)
          [3,6,9].each { |pos| board.put(token: token, position: pos) }
          x_wins = board.in_winning_position?(token: token)

          expect(x_wins).to be true
        end
      end

    end
  end

  describe "#number_of_cells" do
    it 'returns an integer' do
      board = Board.new(dimension: test_dimension)
      expect(board.number_of_cells).to be_kind_of Integer
    end

    it 'returns the squared dimension' do
      board = Board.new(dimension: test_dimension)

      expect(board.number_of_cells).to be test_dimension**2
    end
  end
end
