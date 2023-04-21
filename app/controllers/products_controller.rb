class ProductsController < ApplicationController  
  def index
    @products = Product.select(:id, :name, :price)
  end

  def show
    @product = Product.find(show_permitted_params[:id]) 
  end

  private

  def show_permitted_params
    params.permit(:id)
  end
end
      