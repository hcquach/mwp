namespace :product do
  desc "Update daily app"
  task update_daily_app: :environment do
    @daily_update = true
  end
end
