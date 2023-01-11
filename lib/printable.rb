# frozen_string_literal: true

module Printable
  attr_reader :lines

  # @lines <Array of String>
  def initialize(lines = [])
    @lines = lines
  end

  def add_line(line)
    @lines << line
  end

  def to_s
    "#{self.class}\n" + @lines.join("\n")
  end
end