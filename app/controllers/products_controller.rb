class ProductsController < ApplicationController

  def index
    @products = Product.all.paginate(:page => params[:page]).order('id DESC')
    @products = @products.online(params[:online]).paginate(:page => params[:page]).order('id DESC') if params[:online].present?
    @products = Product.where("description ILIKE ?", "%#{params[:query]}%").paginate(:page => params[:page]).order('id DESC') if params[:query].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

end
