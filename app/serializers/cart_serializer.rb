# frozen_string_literal: true

class CartSerializer < ActiveModel::Serializer
  attributes :products, :total_price
end
