# frozen_string_literal: true

require 'spec_helper'
require 'presenter'
require 'board'
require 'fake_io'


describe Presenter do
  it 'prompts the player to select a position' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.prompt_select_position
    expect(output).to include(/select.*position/i)
  end

  it 'prompts the player to select another position' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.prompt_select_another_position
    expect(output).to include(/select another.*position/i)
  end

  it 'prompts the player their chosen position is invalid' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.tell_position_invalid
    expect(output).to include(/invalid position/i)
  end

  it 'prompts the player their chosen position is taken' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.tell_position_taken
    expect(output).to include(/position.*taken/i)
  end

  context 'when the board is shown' do
    let(:board_output_data) do
      <<~BOARD_RENDER
        1|2|3
        ------
        4|5|6
        ------
        7|8|9
      BOARD_RENDER
    end

    it 'returns the content of each cell in a grid format' do
      presenter = Presenter.new(io: FakeIO.new)
      board = Board.new(dimension: 3)
      board_output = FakeIO.new.output_to_screen board_output_data
      expect(presenter.show_board(board: board)).to eql board_output
    end
  end

  it 'shows whose turn it is' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.show_player_turn(player: 'X')
    expect(output).to include(/Player.*Turn/i)
  end

  it 'tells the user the game is over' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.show_game_over
    expect(output).to include(/game over/i)
  end

  it 'tells the user the game is tied' do
    presenter = Presenter.new(io: FakeIO.new)
    output = presenter.show_tie_game
    expect(output).to include(/tie/i)
  end

  context 'when the game is won, given player tokens X & O' do
    context 'when X wins' do
      it 'tells the user X won the game' do
        presenter = Presenter.new(io: FakeIO.new)
        output = presenter.show_winner_is(token: 'X')
        expect(output).to include(/X.*won/i)
      end

      it "doesn't tell the user O won" do
        presenter = Presenter.new(io: FakeIO.new)
        output = presenter.show_winner_is(token: 'X')
        expect(output).not_to include(/O.*won/i)
      end
    end

    context 'when O wins' do
      it 'tells the user O won the game' do
        presenter = Presenter.new(io: FakeIO.new)
        output = presenter.show_winner_is(token: 'O')
        expect(output).to include(/O.*won/i)
      end

      it "doesn't tell the user X won" do
        presenter = Presenter.new(io: FakeIO.new)
        output = presenter.show_winner_is(token: 'X')
        expect(output).not_to include(/O.*won/i)
      end
    end
  end

  context 'when asked to prompt a specific user message' do
    context 'when POSITION_TAKEN value is given' do
      it 'prompts the player, their chosen position is taken' do
        io = FakeIO.new
        presenter = Presenter.new(io: io)
        presenter.show_player_error_message(message: Presenter::POSITION_TAKEN)
        expect(io.output_stream).to include(/position.*taken/i)
      end
    end

    context 'when POSITION_INVALID value is given' do
      it 'prompts the player, their chosen position is invalid' do
        io = FakeIO.new
        presenter = Presenter.new(io: io)
        presenter.show_player_error_message(message: Presenter::POSITION_INVALID)
        expect(io.output_stream).to include(/invalid.*position/i)
      end
    end

    context 'when SELECT_ANOTHER_POSITION value is given' do 
      it 'promps the player to select another position' do 
        io = FakeIO.new
        presenter = Presenter.new(io: io)
        error_message = Presenter::SELECT_ANOTHER_POSITION
        presenter.show_player_error_message(message: error_message)
        expect(io.output_stream).to include(/select another position/i)
      end 
    end
  end

end
