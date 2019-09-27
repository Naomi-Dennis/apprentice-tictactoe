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

end
