# frozen_string_literal: true

module Api
  class PurchasesController < Api::ApiController
    before_action :authorize_request
    rescue_from OutOfStockError, EmptyCartError, with: :bad_request

    def index
      render json: PurchasesService.user_purchases(@current_user), each_serializer: PurchaseSerializer
    end

    def create
      purchase = PurchasesService.make_purchase(@current_user)
      render json: PurchaseSerializer.new(purchase).to_json
    end
  end
end
