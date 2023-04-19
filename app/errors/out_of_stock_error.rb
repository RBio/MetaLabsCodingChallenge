class OutOfStockError < StandardError
  attr_reader :product_names

  def initialize(product_names)
    @product_names = product_names
  end

  def message
    "The #{('product'.pluralize(product_names.length))} '#{product_names.join(', ')}' ran out of stock"
  end
end