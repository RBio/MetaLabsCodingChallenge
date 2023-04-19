user = User.create(email: 'test@test.com', password: 'testtest')

products = (1..3).map do |i|
  Product.create(name: "test name #{i}", description: "test description #{i}",
                 price: 100 * i, stock: 3)
end

products_without_stock = (1..3).map do |i|
  Product.create(name: "product without stock name #{i}", description: "product without stock description #{i}",
                 price: 200, stock: 0)
end

user_purchase = Purchase.create(user: user)

PurcahseItem.create(purchase: user_purchase, name: products[0].name, description: products[0].description,
                    price: products[0].price, quantity: 1)
PurcahseItem.create(purchase: user_purchase, name: products[2].name, description: products[2].description,
                    price: products[2].price, quantity: 1)
PurcahseItem.create(purchase: user_purchase, name: products_without_stock[1].name, description: products_without_stock[1].description,
                    price: products_without_stock[1].price, quantity: 1)