require 'spec_helper'
require 'main_io'

class FakeStdin
  @@string

  def self.string
    @@string
  end

  def self.string=(string)
    @@string = string
  end

  def self.gets 
    @@string
  end
end

class FakeStdout
  def self.puts(*output)
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
      io = MainIO.new(stdin: FakeStdin, stdout: FakeStdout)
      FakeStdin.string= '1'
      input_result = io.gets
      expect(input_result).to eql test_input
    end

    it 'uses stdin to capture the string' do
      spy = FakeSpy.new
      spy.watch(method: :gets)
      io = MainIO.new(stdin: spy, stdout: FakeStdout)
      io.gets
      expect(spy.times_called).to be 1
    end
  end

  context 'when showing output' do
    it 'returns the captured string' do
      test_output = 'this is a test output'
      io = MainIO.new(stdin: FakeStdin, stdout: FakeStdout)
      output_result = io.puts test_output
      expect(output_result).to eql test_output
    end

    context 'when multiple strings are passed' do
      it 'returns all strings separated by new lines' do
        io = MainIO.new(stdin: FakeStdin, stdout: FakeStdout)
        output_result = io.puts 'this', 'is', 'a', 'test'
        expect(output_result).to eql "this\nis\na\ntest"
      end
    end

    it 'uses stdout to output the string' do
      spy = FakeSpy.new
      spy.watch(method: :puts)
      io = MainIO.new(stdin: FakeStdin, stdout: spy)
      io.puts 'some kind of input'
      expect(spy.times_called).to be 1
    end
  end
end
