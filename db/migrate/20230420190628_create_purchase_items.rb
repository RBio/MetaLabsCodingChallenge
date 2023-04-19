class CreatePurchaseItems < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_items do |t|
      t.references :purchase
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :quantity
      t.timestamps
    end
  end
end
