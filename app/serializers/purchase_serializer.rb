# frozen_string_literal: true

class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :purchase_items, :total_price

  def purchase_items
    object.purchase_items.map do |purchase_item|
      { name: purchase_item.product.name, price: purchase_item.price,
        quantity: purchase_item.quantity }
    end
  end
end
