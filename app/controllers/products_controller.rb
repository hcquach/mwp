class ProductsController < ApplicationController
  def index
    if params[:query].present?
      @products = Product.where("description ILIKE ?", "%#{params[:query]}%")
    else
      @products = Product.all
    end
  end
end
