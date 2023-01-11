# frozen_string_literal: true

class Item
  # @item <OpenStruct>
  def self.build(item)
    Item.new(item.description, item.net_price, item.quantity, item.imported)
  end

  attr_reader :sale_tax, :gross_price, :quantity

  def initialize(description, net_price, quantity = 1, imported = false)
    @description = description if validate_description!(description)
    @net_price = net_price if validate_net_price!(net_price)
    @quantity = quantity if validate_quantity!(quantity)
    @imported = imported

    calculate_taxes
  end

  def to_s
    string = [@quantity.to_s]
    string << 'imported' if @imported
    string << (@description + ':')
    string << sprintf('%.2f', @gross_price)

    string.join(' ')
  end

  private

  def validate_description!(description)
    return true unless description.empty?

    raise 'Item Description is required'
  end

  def validate_net_price!(net_price)
    return true unless net_price < 0

    raise 'NetPrice must be lower than 0'
  end

  def validate_quantity!(quantity)
    return true unless quantity < 1

    raise 'Quantity must be equal or greater than 1'
  end

  BASIC_TAX_RATE = 0.10
  IMPORT_TAX_RATE = 0.05
  EXEMPT_TAX_ITEMS = [
    'book',
    'chocolate bar',
    'box of chocolates',
    'packet of headache pills'
  ].freeze

  def calculate_taxes
    @sale_tax = 0.0

    tax_rate = 0.0
    tax_rate += IMPORT_TAX_RATE if @imported
    tax_rate += BASIC_TAX_RATE unless EXEMPT_TAX_ITEMS.include?(@description)

    @sale_tax = (@net_price * tax_rate * 20).ceil / 20.0
    @gross_price = (@net_price + @sale_tax).round(2) * @quantity
  end
end
