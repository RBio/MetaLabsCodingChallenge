# frozen_string_literal: true

class CreatePurchaseItems < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_items do |t|
      t.references :purchase
      t.references :product
      t.decimal :price
      t.integer :quantity
      t.timestamps
    end
  end
end
