# frozen_string_literal: true

class OutOfStockError < StandardError
  attr_reader :product_names

  def initialize(product_names)
    @product_names = product_names
  end

  def message
    "The #{'product'.pluralize(product_names.length)} #{product_names.to_sentence} ran out of stock"
  end
end
