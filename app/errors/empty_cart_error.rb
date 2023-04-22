class EmptyCartError < StandardError
  def message
    'There are no products to purchase'
  end
end