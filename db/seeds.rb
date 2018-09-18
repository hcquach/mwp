# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'

Product.destroy_all if Rails.env.development?

batch = '173'
product_name = 'gimme-shelter'
url = "https://www.lewagon.com/demoday/#{batch}/#{product_name}"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

contents = html_doc.search("meta[name='description'], meta[property='og:url'], meta[property='og:image']").map { |n|
  n['content']
}
description = contents.first.strip
url = contents.second.strip
image = contents.third.strip

new_product = Product.new(name: product_name)
new_product.batch = batch
new_product.description = description
new_product.site = url
new_product.image = image
new_product.save
puts "New product added"
