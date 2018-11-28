namespace :product do
  desc "Update daily app"
  task update_daily_app: :environment do
    Daily.first.products.push(Product.all.sample)
  end
end
