class PurchasesService
  class << self
    def make_purchase(user)
      products = user.cart.products

      ActiveRecord::Base.transaction do
        products_out_of_stock = update_product_stocks(products)

        raise OutOfStockError.new(products_out_of_stock) if products_out_of_stock.present?

        purchase = Purchase.create(user: user)

        create_purchase_items(purchase, products)

        purchase
      end
    end

    private

    def update_product_stocks(products)
      products_out_of_stock = []

      products.each do |product|
        begin
          product.update(stock: product.stock - 1)
        rescue
          products_out_of_stock << product.name
        end
      end

      products_out_of_stock 
    end

    def create_purchase_items(purchase, products)
      products.each do |product|
        PurchaseItem.create({ purchase: purchase, quantity: 1 }.merge(product.slice(:name, :description, :price)))
      end
    end
  end
end
  