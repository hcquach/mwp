class ProductsController < ApplicationController

  def index
    @products = Product.all
    @products = @products.online(params[:online]) if params[:online].present?
    @products = Product.where("description ILIKE ?", "%#{params[:query]}%") if params[:query].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

end
