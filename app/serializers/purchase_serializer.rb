class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :purchase_items
end
  