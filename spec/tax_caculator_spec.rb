require 'spec_helper'

require_relative '../lib/tax_calculator'

describe TaxCalculator do
  subject { described_class.run(input) }

  shared_examples 'generate right receipt' do
    it { is_expected.to eq(output) }
  end

  context 'Input 1' do
    let(:input) {[
      '2 book at 12.49',
      '1 music CD at 14.99',
      '1 chocolate bar at 0.85',
    ]}

    let(:output) {[
      '2 book: 24.98',
      '1 music CD: 16.49',
      '1 chocolate bar: 0.85',
      'Sales Taxes: 1.50',
      'Total: 42.32',
    ]}

    it_behaves_like 'generate right receipt'
  end

  context 'Input 2' do
    let(:input) {[
      '1 imported box of chocolates at 10.00',
      '1 imported bottle of perfume at 47.50',
    ]}

    let(:output) {[
      '1 imported box of chocolates: 10.50',
      '1 imported bottle of perfume: 54.65',
      'Sales Taxes: 7.65',
      'Total: 65.15',
    ]}

    it_behaves_like 'generate right receipt'
  end

  context 'Input 3' do
    let(:input) {[
      '1 imported bottle of perfume at 27.99',
      '1 bottle of perfume at 18.99',
      '1 packet of headache pills at 9.75',
      '3 imported box of chocolates at 11.25',
    ]}

    let(:output) {[
      '1 imported bottle of perfume: 32.19',
      '1 bottle of perfume: 20.89',
      '1 packet of headache pills: 9.75',
      '3 imported box of chocolates: 35.55',
      'Sales Taxes: 7.90',
      'Total: 98.38',
    ]}

    it_behaves_like 'generate right receipt'
  end
end