# frozen_string_literal: true

require_relative 'printable'

class Output
  include Printable

  attr_reader :lines
end
