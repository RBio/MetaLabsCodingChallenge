# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PurchasesController, type: :request do
  let!(:user) { create(:user) }

  describe 'GET #/user/purchases' do
    context 'when requesting for a user with purchases' do
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

      before do
        get '/api/user/purchases',
            headers: user_auth_headers(user)
      end

      it "should return the user's purchases ordered by descending date" do
        expected_body = formatted_purchases_response([purchase2, purchase1]).to_json

        expect(response).to have_http_status(200)
        expect(response.body).to eq expected_body
      end
    end
  end

  describe 'POST #/user/purchases' do
    let!(:products) do
      (1..3).map { create(:product) }
    end

    context 'when making a purchase with valid products' do
      before do
        user.cart.products << products
        post '/api/user/purchases',
             headers: user_auth_headers(user)
      end

      it 'should complete it successfully, and return it' do
        purchase = user.purchases.first
        expected_body = formatted_purchases_response([purchase])[0]

        expect(response).to have_http_status(201)
        expect(response.body).to eq expected_body.to_json

        purchase_items = purchase.purchase_items

        expect(purchase_items.length).to eq 3
        expect(user.cart.reload.products).to be_empty

        products_stock_before_purchase = products.map(&:stock)
        updated_products_stock = Product.find(purchase_items.pluck(:product_id)).map(&:stock)
        expect(updated_products_stock).to eq products_stock_before_purchase.map { |previous_stock|
                                               previous_stock - 1
                                             }

        purchase_items.each do |purchase_item|
          expect(purchase.user_id).to eq user.id
          expect(purchase_item.purchase_id).to eq purchase.id
          expect(purchase_item.price).to eq purchase_item.product.price
        end
      end
    end

    context 'when attempting to purchase products without stock' do
      let!(:products_without_stock) do
        (1..2).map { create(:product, stock: 0) }
      end
      before do
        user.cart.products << [products, products_without_stock].flatten
        post '/api/user/purchases',
             headers: user_auth_headers(user)
      end

      it 'should return a 400 error with the list of products without stock' do
        error_message = "The products #{products_without_stock[0].name} and #{products_without_stock[1].name} ran out of stock"
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['error']).to eq error_message

        expect(Purchase.all).to be_empty
        expect(PurchaseItem.all).to be_empty
      end
    end

    context 'when attempting to purchase with an empty cart' do
      before do
        post '/api/user/purchases',
             headers: user_auth_headers(user)
      end

      it "should return a 400 error saying that there's no products in cart" do
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['error']).to eq 'There are no products to purchase'

        expect(Purchase.all).to be_empty
        expect(PurchaseItem.all).to be_empty
      end
    end
  end
end

def user_auth_headers(user)
  {
    Authorization: "Bearer #{JsonWebToken.encode(user_id: user.id)}"
  }
end

def formatted_purchases_response(purchases)
  purchases.map do |purchase|
    purchase_items_format = purchase.purchase_items.map do |purchase_item|
      { name: purchase_item.product.name, price: purchase_item.price, quantity: purchase_item.quantity }
    end
    purchase_body = { id: purchase.id, created_at: purchase.created_at,
                      purchase_items: purchase_items_format }
  end
end
