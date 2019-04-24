require 'couchrest'
require 'restclient'
require 'json'
require 'faker'

require 'net/http'
require 'couchrest_model'

# User.create!(email: '1' , password: '1', role_id: 1)


# users_count = 1

# category = Category.create({
#                                title: "Test Category",
#                                description: "BlahBluah Category"
#                            })

# Dir["C:\\Users\\Asus\\inno\\rent-system-couchdb\\app\\models\\*.rb"].each {|file| require file }
# require 'subcategory.rb'
# require_relative 'subcategory'

@db = CouchRest.database!("http://admin:groot@127.0.0.1:5984/rent_couch_d")
categories = ['Animals', 'Body pars', 'Cloths', 'Furniture', 'Musical instruments', 'Sport', 'Electric equipment', 'Other']
# db.save_doc('name' => 'seed_test')

# subcategory = Subcategory.create({
#                                      title: "Teapots",
#                                      description: "Here are some Teapots"
#                                  })
number_of_categories = categories.length
number_of_users = 1000
number_of_orders = 1000
number_of_items = 10000 - number_of_categories - number_of_users - number_of_orders


class Cat < CouchRest::Model::Base
	property :name,        String
	property :last_fed_at, Time
	property :awake,       TrueClass, :default => false
end

# Assign values to the properties on instantiation
# @cat = Cat.new(:name => 'Felix2', :last_fed_at => 10.minutes.ago)
# @db.save_doc(@cat)

require_relative 'subcategory'
require_relative 'user'
require_relative 'item'
require_relative 'order'


def generate_categories(categories)
	categories_ids = Array.new
	categories.each do |category|
		categories_ids << @db.save_doc('type' => 'Subcategory', 
			'title' => category, 
			'description' => Faker::Lorem.sentence)['id']
	end
	return categories_ids
end

def generate_users(number_of_users)
	users_ids = Array.new
	number_of_users.times do
		uri = URI('http://localhost:3000/users')
		http = Net::HTTP.new(uri.host, uri.port)
		req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
		password = Faker::Internet.password(8, 16)
		req.body = {'name' => Faker::Name.first_name,
								'surname' => Faker::Name.last_name,
								'username' => Faker::Internet.username(5..8),
								'phone' => Faker::PhoneNumber.phone_number_with_country_code,
								'email' => Faker::Internet.email,
								'role_id' => 1,
								'password' => password,
								'password_confirmation' => password}.to_json
		res = http.request(req)
		users_ids << JSON.parse(res.body)['data']['_id']
	end
	return users_ids
end

# users_ids = generate_users(1)

def generate_items(number_of_items, users_ids, categories_ids)
	number_of_items.times do
		user_id = users_ids.sample
		category_id = categories_ids.sample
		@db.save_doc('type' => 'Item',
					 'title' => Faker::Device.model_name,
					 'description' => Faker::Lorem.sentence,
					 'price' => Faker::Number.number(3),
					 'duration' => (1 + rand(7)),
					 'subcategory_id' => category_id,
					 'user_id' => user_id,
					 'order_ids' => [])
	end
	return items_ids
end




def generate_orders(number_of_orders, users_ids, items_ids)
	number_of_orders.times do
		user_id = users_ids.sample
		item_id = items_ids.sample
		@db.save_doc('type' => 'Order',
					'status' => rand(2),
					'user_id' => user_id,
					'item_id' => item_id,
					'duration' => rand(4),
					'description' => Faker::Lorem.sentence
		)
	end
end


categories_ids = generate_categories(categories)
users_ids = generate_users(number_of_users)
items_ids = generate_items(number_of_items, users_ids, categories_ids)
generate_orders(number_of_orders, users_ids, items_ids)