class ProductsController < ApplicationController

  def index

    @most_popular = Product.order(votes: :desc).first
    daily_products = Daily.first.products
    @random = daily_products[-1]

    frequencies = Hash.new(0)
    all_words = ""
    Product.all.each do |product|
      all_words += product.description
    end
    words = all_words.split(/, |\s|\:|\. |\'|\.|!|-/)
    words.each do |word|
      frequencies[word.downcase] += 1 if !word.empty?
    end
    File.open(File.dirname(__FILE__) + "/../assets/config/stop_words.txt", "r").each_line { |line| frequencies.delete(line.split[0]) }
    @frequencies = frequencies.max_by(6) { |max_value| max_value[1] }.to_h

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
