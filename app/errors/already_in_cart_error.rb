class AlreadyInCartError < StandardError
  def message
    'Product already in cart'
  end
end