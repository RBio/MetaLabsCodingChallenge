class ProductsController < ApplicationController  
  def index
    @products = Product.select(:id, :name, :price)
  end

  def show
    product_id = show_permitted_params[:id].to_i
    @product = Product.find(product_id) 
    @product_in_cart = current_user.cart.products.exists?(id: product_id)
  end

  private

  def show_permitted_params
    params.permit(:id)
  end
end
      