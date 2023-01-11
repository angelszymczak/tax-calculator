require 'spec_helper'

require_relative '../lib/tax_calculator'

describe TaxCalculator do
  subject { described_class.run(input) }

  context 'Input 1' do
    let(:input) do
      [
        '2 book at 12.49',
        '1 music CD at 14.99',
        '1 chocolate bar at 0.85',
      ]
    end

    let(:output) do
      [
        '2 book: 24.98',
        '1 music CD: 16.49',
        '1 chocolate bar: 0.85',
        'Sales Taxes: 1.50',
        'Total: 42.32',
      ]
    end

    it { is_expected.to eq(output) }
  end
end