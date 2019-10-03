class FakeIO
  attr_accessor :input_stream, :output_stream

  def initialize(output_stream: [], input_stream: '')
    @output_stream = output_stream
    @input_stream = input_stream
  end

  def output_to_screen(*output)
    @output_stream << output.join("\n")
    @output_stream
  end

  def get_keyboard_input
    @input_stream.to_s
  end

  def current_output
    @output_stream
  end
end
