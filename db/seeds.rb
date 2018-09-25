# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'
require "net/http"

# Alumni.destroy_all if Rails.env.development?
# Product.destroy_all if Rails.env.development?

# Last batch number to end the loop
last_batch = 178

# Loop through each batch
for i in 177..last_batch do

  batch_url = "https://www.lewagon.com/demoday/#{i}"

  url = URI.parse(batch_url)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = true
  res = req.request_head(url.path)

  next if res.code != '200'

  html_batch_file = open(batch_url).read
  html_batch_doc = Nokogiri::HTML(html_batch_file)

  # Get each product url in an array
  scraped_text = html_batch_doc.search('.container.demo-section').first.to_s.gsub(/&quot;/, '"').match(/products.*"students"/).to_s
  products_url = scraped_text.split(/"slug\"/)
  products_url.shift
  products_url.each do |element|

    product_url = element.match(/url.*tagline/).to_s[6..-11]
    product_name = element.match(/.*"url/).to_s[2..-7].gsub(" ", "%20")

    product_demoday_url = "https://www.lewagon.com/demoday/#{i}/#{product_name}"
    html_product_file = open(product_demoday_url).read
    html_product_doc = Nokogiri::HTML(html_product_file)

    contents = html_product_doc.search("meta[name='description'], meta[property='og:image']").map { |n|
      n['content']
    }
    product_description = contents.first.strip
    product_image = contents.second.strip

    new_product = Product.new
    new_product.name = html_product_doc.search('title').text.match(/.*- L/).to_s[0..-4].strip
    new_product.batch = i
    new_product.city = html_product_doc.search('title').text.match(/- Le Wagon.*Batch/).to_s[10..-8].strip
    new_product.description = product_description
    new_product.site = product_url
    begin
      new_product.online = true if open(product_url).read
    rescue
      new_product.online = false
    end
    new_product.image = product_image
    new_product.year = html_batch_doc.search('.container.demo-section').first.to_s.gsub(/&quot;/, '"').match(/ends_at.*meta_/).to_s[-12..-9]
    new_product.votes = 0
    new_product.save
    puts "New product added"

    element.match(/name.*/).to_s.split('{').each do |alumni|
      new_alumni_name = alumni.match(/name.*official*/).to_s[7..-12]
      if new_alumni_name
        new_alumni = Alumni.new(name: new_alumni_name)
        new_alumni.photo = alumni.match(/avatar_url.*hide/).to_s[13..-8]
        new_alumni.product_id = new_product.id
        new_alumni.save
        puts "New alumni added"
      end
    end

  end

end

# batch = '173'
# product_name = 'gimme-shelter'
# url = "https://www.lewagon.com/demoday/#{batch}/#{product_name}"

# html_file = open(url).read
# html_doc = Nokogiri::HTML(html_file)


