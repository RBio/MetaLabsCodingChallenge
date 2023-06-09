# frozen_string_literal: true

class CartsController < ApplicationController
  rescue_from AlreadyInCartError, OutOfStockError, with: :error_handler

  def show
    cart = current_user.cart
    @products = cart.products
    @total_price = cart.total_price
  end

  def add_product
    CartsService.add_product(current_user.cart, cart_permitted_params[:product_id].to_i)
    redirect_to cart_path(current_user.cart.id), notice: 'The product has been added to your cart'
  end

  def remove_product
    CartsService.remove_product(current_user.cart, cart_permitted_params[:product_id].to_i)
    redirect_to cart_path(current_user.cart.id), notice: 'The product has been removed from your cart'
  end

  private

  def cart_permitted_params
    params.permit(:product_id)
  end
end
