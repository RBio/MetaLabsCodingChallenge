# frozen_string_literal: true

user = User.create(email: 'test@test.com', password: 'testtest')
another_user = User.create(email: 'another_test@test.com', password: 'testtest')

products = (1..3).map do |i|
  Product.create(name: "test name #{i}", description: "test description #{i}",
                 price: 100 * i, stock: 3)
end

products_without_stock = (1..3).map do |i|
  Product.create(name: "product without stock name #{i}", description: "product without stock description #{i}",
                 price: 200, stock: 0)
end

user_purchase_1 = Purchase.create(user:)

PurchaseItem.create(purchase: user_purchase_1, product: products[0], price: products[0].price, quantity: 1)
PurchaseItem.create(purchase: user_purchase_1, product: products[2], price: products[2].price - 10, quantity: 1)
PurchaseItem.create(purchase: user_purchase_1, product: products_without_stock[1], 
                    price: products_without_stock[1].price - 50, quantity: 1)

user_purchase_2 = Purchase.create(user:)

PurchaseItem.create(purchase: user_purchase_2, product: products[0], price: products[0].price, quantity: 1)

another_user_purchase = Purchase.create(user: another_user)

PurchaseItem.create(purchase: another_user_purchase, product: products[0], price: products[0].price, quantity: 1)
PurchaseItem.create(purchase: another_user_purchase, product: products[0], price: products[1].price, quantity: 1)
