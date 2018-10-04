class ProductsController < ApplicationController

  def index
    @products = Product.all.paginate(:page => params[:page])
    @products = @products.city(params[:city]).paginate(:page => params[:page]) if params[:city].present?
    @products = @products.year(params[:year]).paginate(:page => params[:page]) if params[:year].present?
    @products = @products.online(params[:online]).paginate(:page => params[:page]) if params[:online].present?
    @products = Product.where("description ILIKE ?", "%#{params[:query]}%").paginate(:page => params[:page]) if params[:query].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

end
