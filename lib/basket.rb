# frozen_string_literal: true

require 'ostruct'
require 'output'

require_relative 'item'

class Basket
  # @input <Input>
  def self.build(input)
    basket = Basket.new
    input.lines.each do |line|
      parse!(line).tap { |item| basket.add_item(item) }
    end

    basket
  end

  # @line <String>
  def self.parse!(line)
    item = OpenStruct.new
    words = line.split(' ')
    validate_line!(words)

    item.quantity = parse_quantity!(words)
    item.net_price = parse_net_price!(words)

    imported_idx = parse_imported_idx!(words)
    item.imported = !imported_idx.nil?

    item.description = parse_description(item, imported_idx, words)

    item
  rescue Exception => e
    $logger.error(e.message)
    raise e
  end

  MIN_WORDS_PER_LINE = 4
  BEFORE_LAST_WORD_OFFSET = 2
  BEFORE_LAST_WORD = 'at'.freeze
  # @words <Array of String>
  def self.validate_line!(words)
    unless (words_count = words.size) >= MIN_WORDS_PER_LINE
      raise Exception,
        'Expected item in the form [quantity] [description] at [net_price], but we received: ' +
        words_count
    end

    unless (before_last_word = words[words_count - BEFORE_LAST_WORD_OFFSET]) == BEFORE_LAST_WORD
      raise Exception,
        'Expected item in the form [quantity] [description] at [net_price], but -- missing "at", we received: ' +
        before_last_word
    end
  end

  QUANTITY_INDEX = 0
  # @words <Array of String>
  def self.parse_quantity!(words)
    quantity = words[QUANTITY_INDEX]
    validate_integer_word!(quantity)

    quantity.to_i
  end

  INTEGER_REGEX = /\A\d+\Z/
  def self.validate_integer_word!(word)
    unless word.match?(INTEGER_REGEX)
      raise Exception,
        'Expected word to be a number, but we received: '
        + word
    end
  end

  NET_PRICE_OFFSET = 1
  # @words <Array of String>
  def self.parse_net_price!(words)
    net_price = words[words.count - NET_PRICE_OFFSET]
    validate_price_word!(net_price)

    net_price.to_f
  end

  DECIMAL_REGEX = /^(?=.)(([0-9]*)(\.([0-9]+))?)$/
  def self.validate_price_word!(price)
    unless price.match?(DECIMAL_REGEX)
      raise Exception,
        'Expected word to be a number integer or decimal, but we received: '
        + word
    end
  end

  IMPORTED_ID = 'imported'
  # @words <Array of String>
  def self.parse_imported_idx!(words)
    (words.map { |word| word.downcase }).index(IMPORTED_ID)
  end

  # @item OpenStruct
  # @words <Array of String>
  def self.parse_description(item, imported_idx, words)
    # - remove 'quantity' word
    # - remove 'price' word
    if item.imported
      # remove 'imported' word
      words[1..(imported_idx - 1)] + words[imported_idx + 1..(words.count - 3)]
    else
      words[1..(words.count - 3)]
    end.join(' ')
  end

  private_class_method :parse!, :validate_line!, :parse_quantity!, :validate_integer_word!, :parse_net_price!, :validate_price_word!, :parse_imported_idx!, :parse_description

  attr_reader :items

  def initialize
    @items = []
  end

  # @item <OpenStruct>
  def add_item(item)
    @items << Item.build(item)
  end

  def generate_receipt
    total_sales_tax = 0.0
    total = 0.0

    output = Output.new
    @items.each do |item|
      output.add_line(item.to_s)

      total_sales_tax += item.sale_tax * item.quantity
      total += item.gross_price
    end

    output.add_line("Sales Taxes: #{sprintf('%.2f', total_sales_tax)}")
    output.add_line("Total: #{sprintf('%.2f', total)}")

    output
  end
end