# frozen_string_literal: true

class PurchasesController < ApplicationController
  rescue_from OutOfStockError, EmptyCartError, with: :error_handler

  def index
    @purchases = PurchasesService.user_purchases(current_user)
  end

  def create
    PurchasesService.make_purchase(current_user)
    redirect_to purchases_path, notice: 'Your order has been placed'
  end
end
