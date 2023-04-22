# frozen_string_literal: true

module Api
  class ProductsController < Api::ApiController
    before_action :authorize_request

    def index
      render json: Product.all, each_serializer: ProductSerializer
    end

    def show
      render json: Product.find(show_permitted_params[:id].to_i)
    end

    private

    def show_permitted_params
      params.permit(:id)
    end
  end
end
