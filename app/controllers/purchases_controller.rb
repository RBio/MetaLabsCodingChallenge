# frozen_string_literal: true

class PurchasesController < ApplicationController
  def index
    @purchases = PurchasesService.user_purchases(current_user)
  end

  def create
    PurchasesService.make_purchase(current_user)
    redirect_to purchases_path
  end
end
