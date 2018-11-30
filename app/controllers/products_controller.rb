class ProductsController < ApplicationController

  def index

    @most_popular = Product.order(votes: :desc).first
    daily_products = Daily.first.products
    @random = daily_products[-1]

    if params[:query].present?
      sql_query = "name ILIKE :query OR description ILIKE :query"
      @products = Product.where(sql_query, query: "%#{params[:query]}%").paginate(:page => params[:page]).order('id DESC')
    elsif params[:online].present?
      @products = Product.online(params[:online]).paginate(:page => params[:page]).order('id DESC')
    else
      @products = Product.all.paginate(:page => params[:page]).order('id DESC')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

end
