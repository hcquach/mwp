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

# Last batch number to end the loop
last_batch = 1

# Loop through each batch
for i in 1..last_batch do

  batch_url = "https://www.lewagon.com/demoday/#{i}"
  html_batch_file = open(batch_url).read
  html_batch_doc = Nokogiri::HTML(html_batch_file)

  # Get each product url in an array
  scraped_text = html_batch_doc.search('.container.demo-section').first.to_s.match(/products.*"students"/).to_s
  products_url = scraped_text.split("slug")
  products_url.shift
  products_url.each do |element|
    product_name = element.replace(element.match(/.*"url/).to_s[3..-7])

    product_demoday_url = "https://www.lewagon.com/demoday/#{i}/#{product_name}"
    html_product_file = open(product_demoday_url).read
    html_product_doc = Nokogiri::HTML(html_product_file)

    contents = html_product_doc.search("meta[name='description'], meta[property='og:url'], meta[property='og:image']").map { |n|
      n['content']
    }
    product_description = contents.first.strip
    product_url = contents.second.strip
    product_image = contents.third.strip

    new_product = Product.new
    new_product.name = html_product_doc.search('title').text.match(/.*- L/).to_s[0..-4].strip
    new_product.batch = i
    new_product.city = html_product_doc.search('title').text.match(/Wagon.*Batch/).to_s[5..-8].strip
    new_product.description = product_description
    new_product.site = product_url
    new_product.image = product_image
    new_product.year = html_batch_doc.search('.container.demo-section').first.to_s.match(/ends_at.*meta/).to_s[-11..-8]
    new_product.votes = 0
    new_product.save
    puts "New product added"
  end

end




# batch = '173'
# product_name = 'gimme-shelter'
# url = "https://www.lewagon.com/demoday/#{batch}/#{product_name}"

# html_file = open(url).read
# html_doc = Nokogiri::HTML(html_file)


