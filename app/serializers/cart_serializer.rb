# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :products, :total_price

  def products
    object.products.map { |product| product.attributes.except('created_at', 'updated_at') }
  end
end
