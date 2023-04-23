# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :user
  has_many :purchase_items

  def total_price
    purchase_items.sum(:price)
  end
end
