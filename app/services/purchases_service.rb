# frozen_string_literal: true

class PurchasesService
  class << self
    def make_purchase(user)
      cart = user.cart
      products = cart.products

      raise EmptyCartError if products.empty?

      ActiveRecord::Base.transaction do
        products_out_of_stock = update_product_stocks(products)

        raise OutOfStockError, products_out_of_stock if products_out_of_stock.present?

        purchase = Purchase.create(user:)

        create_purchase_items(purchase, products)

        cart.products.delete_all

        purchase
      end
    end

    def user_purchases(user)
      Purchase.where(user:).includes(:purchase_items, purchase_items: :product)
              .order(created_at: :desc)
    end

    private

    def update_product_stocks(products)
      products_out_of_stock = []

      products.each do |product|
        product.update(stock: product.stock - 1)
      rescue StandardError
        products_out_of_stock << product.name
      end

      products_out_of_stock
    end

    def create_purchase_items(purchase, products)
      products.each do |product|
        PurchaseItem.create(purchase:, quantity: 1, product:, price: product.price)
      end
    end
  end
end
