require 'pry-byebug'

class ProductsController < ApplicationController

  def index

    @skello = Product.where(name: "Skello")
    @random = Daily.first.products.last

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
