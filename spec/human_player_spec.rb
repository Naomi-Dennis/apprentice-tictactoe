# frozen_string_literal: true

require 'spec_helper'
require 'human_player'
require 'user_input'
require 'fake_io'
require 'board'
require 'presenter'

describe HumanPlayer do
  let(:human) do
    HumanPlayer.new(token: 'X',
                    user_input: UserInput.new(io: FakeIO.new(input_stream: '1')))
  end

  describe '#token' do
    it 'returns a string' do
      expect(human.token).to be_kind_of String
    end

    it 'returns a string with one character' do
      expect(human.token.size).to be 1
    end
  end

  describe '#position' do
    def human_player(input:)
      io = FakeIO.new(input_stream: input)
      HumanPlayer.new(token: 'X',
                      user_input: UserInput.new(io: io))
    end

    context 'when the player enters a valid position' do
      it 'returns a hash' do
        board = Board.new(dimension: 3)
        position = human.position(board: board)
        expect(position).to be_kind_of Hash
      end

      it 'the space key is an integer' do
        board = Board.new(dimension: 3)
        position_object = human.position(board: board)
        position = position_object[:space]
        expect(position).to be_kind_of Integer
      end

      it 'the status key is a symbol' do
        board = Board.new(dimension: 3)
        position_object = human.position(board: board)
        status = position_object[:status]
        expect(status).to be_kind_of Symbol
      end
    end

    context 'when the player enters an invalid position' do
      it 'returns a hash' do
        board = Board.new(dimension: 3)
        position = human.position(board: board)
        expect(position).to be_kind_of Hash
      end

      it 'the space key is nil' do
        board = Board.new(dimension: 3)
        human = human_player(input: -1)
        position_object = human.position(board: board)
        position = position_object[:space]
        expect(position).to be_kind_of NilClass
      end

      it 'the status key is a symbol' do
        board = Board.new(dimension: 3)
        human = human_player(input: -1)
        position_object = human.position(board: board)
        status = position_object[:status]
        expect(status).to be_kind_of Symbol
      end
    end
  end
end
