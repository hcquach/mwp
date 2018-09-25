class ProductsController < ApplicationController
  def index
    @products = Product.where("description ILIKE ?", "%#{params[:keyword]}%")
  end
end
