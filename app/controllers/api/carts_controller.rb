class Api::CartsController < Api::ApiController
  before_action :authorize_request
  rescue_from AlreadyInCartError, OutOfStockError, :with => :bad_request

  def show
    render json: @current_user.cart
  end

  def add_product
    render json: CartService.add_product(@current_user.cart, product_permitted_params[:product_id])
  end

  def remove_product
    render json: CartService.remove_product(@current_user.cart, product_permitted_params[:product_id])
  end

  private

  def show_permitted_params
    params.permit(:user_id)
  end

  def product_permitted_params
    params.permit(:product_id)
  end
end
  