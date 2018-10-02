class ProductsController < ApplicationController

  def index
    @products = Product.all
    @products = @products.city(params[:city]) if params[:city].present?
    @products = @products.year(params[:year]) if params[:year].present?
    @products = @products.online(params[:online]) if params[:online].present?
    @products = Product.where("description ILIKE ?", "%#{params[:query]}%") if params[:query].present?
  end

end
