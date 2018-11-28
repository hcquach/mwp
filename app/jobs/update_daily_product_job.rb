class UpdateDailyProductJob < ApplicationJob
  queue_as :default

  def perform
    product = Product.all.sample
    return product.id
  end
end
