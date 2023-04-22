class CartsController < ApplicationController  
  def show
    @products = current_user.cart.products
  end

  def add_product
    CartsService.add_product(current_user.cart, cart_permitted_params[:product_id].to_i)
  end

  def remove_product
    CartsService.remove_product(current_user.cart, cart_permitted_params[:product_id].to_i)
  end

  private

  def cart_permitted_params
    params.permit(:product_id)
  end
end
        