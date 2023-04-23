# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurchasesService do
  let!(:user) { create(:user) }

  describe 'user_purchases' do
    context 'when sending a user with purchases' do
      let!(:purchase1) { create(:purchase, user:, created_at: Date.yesterday) }
      let!(:purchase_items1) do
        (1..3).map { |i| create(:purchase_item, purchase: purchase1, price: 10 * i) }
      end
      let!(:purchase2) { create(:purchase, user:, created_at: Date.today) }
      let!(:purchase_items2) do
        create(:purchase_item, purchase: purchase2, price: 123)
      end

      let!(:another_user) { create(:user) }
      let!(:another_user_purchase) { create(:purchase, user: another_user) }
      let!(:another_user_purchase_items) do
        create(:purchase_item, purchase: another_user_purchase, price: 4000)
      end

      it "should return the user's purchases ordered by descending date" do
        user_purchases = PurchasesService.user_purchases(user)
        expect(user_purchases.length).to eq 2
        expect(user_purchases.first).to eq purchase2
        expect(user_purchases.second).to eq purchase1
        expect(user_purchases).to eq user.purchases.order(created_at: :desc)
      end
    end

    context 'when sending a user without purchases' do
      it 'should return an empty list' do
        expect(PurchasesService.user_purchases(user)).to be_empty
      end
    end
  end

  describe 'make_purchase' do
    let!(:products) do
      (1..3).map { create(:product) }
    end

    context 'when all products have stock' do
      before do
        user.cart.products << products
      end

      it "the purchase and purchase items are created successfully, decreases stock for each product, and it empties the user's cart" do
        products_to_purchase_stock = products.map(&:stock)

        purchase = PurchasesService.make_purchase(user)
        purchase_items = purchase.purchase_items

        expect(purchase_items.length).to eq 3
        expect(user.cart.products).to be_empty

        updated_products_stock = Product.find(purchase_items.pluck(:product_id)).map(&:stock)
        expect(updated_products_stock).to eq products_to_purchase_stock.map { |previous_stock|
                                               previous_stock - 1
                                             }

        purchase_items.each do |purchase_item|
          expect(purchase.user_id).to eq user.id
          expect(purchase_item.purchase_id).to eq purchase.id
          expect(purchase_item.price).to eq purchase_item.product.price
        end
      end
    end

    context 'when some products ran out of stock' do
      let!(:products_without_stock) do
        (1..2).map { create(:product, stock: 0) }
      end
      before do
        user.cart.products << [products, products_without_stock].flatten
      end

      it 'the purchase is not created, and returns an error with the list of products without stock' do
        error_message = "The products #{products_without_stock[0].name} and #{products_without_stock[1].name} ran out of stock"
        expect { PurchasesService.make_purchase(user) }.to raise_error(OutOfStockError, error_message)
        expect(Purchase.all).to be_empty
        expect(PurchaseItem.all).to be_empty
      end
    end

    context 'when the user does not have products in the cart' do
      it "the purchase is not created, and returns an error saying that there's no products in cart" do
        expect do
          PurchasesService.make_purchase(user)
        end.to raise_error(EmptyCartError, 'There are no products to purchase')
        expect(Purchase.all).to be_empty
        expect(PurchaseItem.all).to be_empty
      end
    end
  end
end
