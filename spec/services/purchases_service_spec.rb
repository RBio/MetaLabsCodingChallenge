# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurchasesService do
  let!(:user) { create(:user) }

  describe 'user_purchases' do
    context 'when sending a valid user' do
      before do

      end

      it "show the user's purchases ordered by descending date" do
      end
    end
  end

  describe 'make_purchase' do
    let!(:products) do
      (1..3).map { create(:product) }
    end

    before do
      user.cart.products << products
    end

    context 'when all products have stock' do
      it 'the purchase is created successfully' do
        purchase = PurchasesService.make_purchase(user)
        purchase_items = PurchaseItem.where(purchase:)
        expect(purchase_items.length).to eq 3
        purchase_items.each do |purchase_item|
          
        end
      end
    end

    context 'when some products ran out of stock' do
      before do
      end

      it 'the pruchase is not created, and returns an error with the list of products without stock' do
      end
    end

    context 'when the user does not have products in the cart' do
      before do
      end

      it "the pruchase is not created, and returns an error saying that there's no products in cart" do
      end
    end
  end
end
