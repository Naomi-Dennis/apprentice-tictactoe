require 'spec_helper'
require 'menu'
require 'fake_io'

class FakeUserInput
  attr_accessor :io

  def initialize(io:)
    @io = io
  end

  def input_position
    @io.get_keyboard_input.to_i
  end
end

describe Menu do
  def test_input(input: -1)
    FakeUserInput.new(io: FakeIO.new(input_stream: input))
  end

  describe '#add_option' do
    it 'can add a selection' do
      menu = Menu.new(user_input: test_input)

      menu_options = menu.add_option(option: 'selection-1')

      expect(menu_options.first).to eql 'selection-1'
    end
  end

  describe '#accept_user_selection' do
    context 'when the user enters one' do
      it 'returns the first option as a symbol' do
        menu = Menu.new(user_input: test_input(input: 1))
        first_option = 'selection-1'
        menu.add_option(option: first_option)

        selected_option = menu.accept_user_selection

        expect(selected_option).to eql first_option
      end
    end
  end

  describe '#option_at' do
    it 'returns an option at a position' do
      menu = Menu.new(user_input: test_input)

      menu.add_option(option: 'selection-1')

      expect(menu.option_at(position: 1)).to eql 'selection-1'
    end
  end
end
