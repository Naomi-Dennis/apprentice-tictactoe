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

end
