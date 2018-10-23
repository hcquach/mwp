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

Alumni.destroy_all if Rails.env.development?
Product.destroy_all if Rails.env.development?

# Last batch number to end the loop
last_batch = 178

# Default photos
default_product_image = "https://dwj199mwkel52.cloudfront.net/assets/social/home_facebook_card-c24af70e1ea78ec96cdf28f926fc76eb3ce3ecaf973042255492aa1de7727393.jpg"
default_alumni_avatar = "https://pbs.twimg.com/profile_images/803890656410095616/rOhjFcOP_400x400.jpg"

# Loop through each batch
for i in 133..last_batch do

  batch_url = "https://www.lewagon.com/demoday/#{i}"

  url = URI.parse(batch_url)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = true
  res = req.request_head(url.path)

  # Skip if demo day page doesn't exist
  next if res.code != '200'

  html_batch_file = open(batch_url).read
  html_batch_doc = Nokogiri::HTML(html_batch_file)

  # Get each product url in an array
  scraped_text = html_batch_doc.search('.container.demo-section').first.to_s.gsub(/&quot;/, '"').match(/products.*"students"/).to_s
  products_url = scraped_text.split(/"slug\"/)
  products_url.shift

  # Iterate over the array of products urls of the batch i
  products_url.each do |element|

    # Regex to retrieve product url and name
    product_url = element.match(/url.*tagline/).to_s[6..-11]
    product_name = element.match(/.*"url/).to_s[2..-7].gsub(" ", "%20")

    # Variables to scrape content of the product
    product_demoday_url = "https://www.lewagon.com/demoday/#{i}/#{product_name}"
    html_product_file = open(product_demoday_url).read
    html_product_doc = Nokogiri::HTML(html_product_file)

    contents = html_product_doc.search("meta[name='description'], meta[property='og:image']").map { |n|
      n['content']
    }
    product_description = contents.first.strip
    product_image = contents.second.strip

    # Creating the product with the relevant info
    new_product = Product.new
    new_product.name = html_product_doc.search('title').text.match(/.*- L/).to_s[0..-4].strip
    new_product.batch = i
    new_product.city = html_product_doc.search('title').text.match(/- Le Wagon.*Batch/).to_s[10..-8].strip
    new_product.description = product_description
    new_product.site = product_url

    # Catch when the product site doesn't respond
    begin
      new_product.online = true if open(product_url).read
    rescue
      new_product.online = false
    end

    # Catch when the product image doesn't exist anymore
    begin
      new_product.image = product_image if open(product_image).read
    rescue
      new_product.image = default_product_image
    end

    new_product.year = html_batch_doc.search('.container.demo-section').first.to_s.gsub(/&quot;/, '"').match(/ends_at.*meta_/).to_s[-12..-9]
    new_product.votes = 0
    new_product.save
    puts "New product added"

    # Loop to retrieve the alumni info
    element.match(/name.*/).to_s.split('{').each do |alumni|
      new_alumni_name = alumni.match(/name.*official*/).to_s[7..-12]
      if new_alumni_name
        new_alumni = Alumni.new(name: new_alumni_name)
        new_avatar_url = alumni.match(/avatar_url.*hide/).to_s[13..-8]

         # Catch when the alumni avatar doesn't exist anymore
        begin
          new_alumni.photo = new_avatar_url if open(new_avatar_url).read
        rescue
          new_alumni.photo = default_alumni_avatar
        end

        new_alumni.product_id = new_product.id
        new_alumni.save
        puts "New alumni added"
      end
    end

  end

end


