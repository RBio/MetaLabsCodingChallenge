class PurchasesController < ApplicationController  
  def index
    @purchases = Purchase.where(user: current_user).includes(:purchase_items)
                         .order(created_at: :desc)
  end

  def create
    PurchasesService.make_purchase(current_user)
    redirect_to purchases_path
  end
end
        