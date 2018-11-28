class Product < ApplicationRecord
  has_many :alumnis
  belongs_to :daily, optional: true

  scope :city, -> (city) { where city: city }
  scope :year, -> (year) { where year: year }
  scope :online, -> (online) { where online: online }

  self.per_page = 72

end
