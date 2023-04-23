# frozen_string_literal: true

class ProductListSerializer < ActiveModel::Serializer
  attributes :name, :price
end
