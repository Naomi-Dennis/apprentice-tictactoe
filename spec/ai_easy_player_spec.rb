# frozen_string_literal: true

require 'spec_helper'
require 'ai_easy_player'
require 'board'

describe AiEasyPlayer do
  let (:ai) { AiEasyPlayer.new(token: 'X') }
  let (:default_board) { board = Board.new(dimension: 3) }
  describe '#token' do
    it 'returns a string' do
      expect(ai.token).to be_kind_of String
    end

    it 'returns a string with one character' do
      expect(ai.token.size).to be 1
    end
  end


  describe '#position' do
    it 'returns a hash' do
      ai_position = ai.position(board: default_board)
      expect(ai_position).to be_kind_of Hash
    end

    it 'the status attribute is always :valid' do
      ai_position = ai.position(board: default_board)
      expect(ai_position[:status]).to be :valid
    end

    context 'when the space attribute is generated' do
      it "it's an integer" do
        ai_position = ai.position(board: default_board)
        expect(ai_position[:space]).to be_kind_of Integer
      end

      it "it's within the confines of the board" do
        ai_position = ai.position(board: default_board)
        space_witin_board = ai_position[:space] >= 1 &&
                            ai_position[:space] <= default_board.number_of_cells

        expect(space_witin_board).to be true
      end

      it 'the space is generated from unoccupied positions' do
        board = Board.new(dimension: 2)
        board.put(token: 'P', position: 1)
        3.times { board.put(token: 'X', position: ai.position(board: board)[:space]) }
        cells = (1..4).collect { |pos| board.at(position: pos) }
        expect(cells).to include 'P' && 'X'
      end
    end
  end
end
