# frozen_string_literal: true

class MainIO
  def initialize(input_stream:, output_stream:)
    @input_stream = input_stream
    @output_stream = output_stream
  end

  def get_keyboard_input
    @input_stream.gets
  end

  def output_to_screen(*output)
    @output_stream.puts output.join("\n")
  end
end
