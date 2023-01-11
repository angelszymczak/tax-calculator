# frozen_string_literal: true

module Printable
  # @lines <Array of String>
  def initialize(lines)
    @lines = lines
  end

  def to_s
    "#{self.class}\n" + @lines.join("\n")
  end
end