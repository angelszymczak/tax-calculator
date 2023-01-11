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

  context 'Input 2' do
    let(:input) do
      [
        '1 imported box of chocolates at 10.00',
        '1 imported bottle of perfume at 47.50',
      ]
    end

    let(:output) do
      [
        '1 imported box of chocolates: 10.50',
        '1 imported bottle of perfume: 54.65',
        'Sales Taxes: 7.65',
        'Total: 65.15',
      ]
    end

    it { is_expected.to eq(output) }
  end
end