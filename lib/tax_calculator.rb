# frozen_string_literal: true

require_relative 'custom_logger'

$logger = CustomLogger.new('tax_calculator.log')
$logger.progname = 'TaxCalculator'

require_relative 'input'
require_relative 'cash_register'

class TaxCalculator
  def self.run(raw_input)
    input = Input.new(raw_input)
    $logger.info(input)

    output = CashRegister.generate_recipe(input)
    $logger.info(output)

    output
  rescue Exception => e

    $logger.error(e.message)
    raise e
  end
end