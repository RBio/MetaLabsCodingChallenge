class CartsService
  class << self
    def add_product(cart, product_id)
      product = Product.find(product_id)
      cart_product_ids = cart.products.pluck(:id)
      raise AlreadyInCartError if cart_product_ids.include?(product.id)
      raise OutOfStockError.new([product.name]) if product.stock.zero?
      cart.products << product
    end
    
    def remove_product(cart, product_id)
      cart.products.delete(product_id)
    end
  end
end
