# frozen_string_literal: true

class CreateCart < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :user

      t.timestamps
    end

    create_join_table :carts, :products
  end
end
