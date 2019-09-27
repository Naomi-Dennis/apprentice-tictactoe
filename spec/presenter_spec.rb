require 'spec_helper'
require 'presenter'
require 'board'

class FakeIO
  def initialize(stdout: [])
    @stdout = stdout
  end

  def self.puts(*output)
    @stdout << output.join("\n")
    @stdout
  end
end

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
    let(:board_output) do
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
      board = Board.new(layout: [*1..9].map!(&:to_s))
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
end
