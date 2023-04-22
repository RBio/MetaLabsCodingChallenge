# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products

  def total_price
    products.sum(:price)
  end
end
