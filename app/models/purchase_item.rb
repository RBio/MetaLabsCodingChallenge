# frozen_string_literal: true

class PurchaseItem < ApplicationRecord
  validates :price, numericality: { greater_than: 0 }

  belongs_to :purchase
  belongs_to :product
end
