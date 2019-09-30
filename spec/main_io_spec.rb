require 'spec_helper'
require 'main_io'

class FakeStdin
  attr_accessor :string
  def initialize(string: '')
    @string = string
  end

  def gets
    @string
  end
end

class FakeStdout
  def puts(*output)
    output.join("\n")
  end
end

class FakeSpy
  attr_accessor :times_called

  def initialize
    @times_called = 0
  end

  def watch(method:)
    define_singleton_method(method) { |*| self.times_called += 1 }
  end
end

describe MainIO do
  context 'when accepting user input' do
    it 'returns captured string' do
      test_input = '1'
      stdin = FakeStdin.new(string: test_input)
      io = MainIO.new(stdin: stdin, stdout: FakeStdout.new)
      input_result = io.gets
      expect(input_result).to eql test_input
    end
  end

  context 'when showing output' do
    it 'returns the captured string' do
      test_output = 'this is a test output'
      io = MainIO.new(stdin: FakeStdin.new, stdout: FakeStdout.new)
      output_result = io.puts test_output
      expect(output_result).to eql test_output
    end

    context 'when multiple strings are passed' do
      it 'returns all strings separated by new lines' do
        io = MainIO.new(stdin: FakeStdin.new, stdout: FakeStdout.new)
        output_result = io.puts 'this', 'is', 'a', 'test'
        expect(output_result).to eql "this\nis\na\ntest"
      end
    end
  end
end
