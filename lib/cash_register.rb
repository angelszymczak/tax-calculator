# frozen_string_literal: true

require_relative 'basket'

class CashRegister
  # @input <Input>
  def self.generate_recipe(input)
    basket = Basket.build(input)
    basket.generate_receipt
  end
end
