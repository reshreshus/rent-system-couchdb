# require 'couchrest'
# require 'restclient'
# require 'json'
# require 'faker'

# require 'net/http'
# require 'couchrest_model'

# # User.create!(email: '1' , password: '1', role_id: 1)


# # users_count = 1

# # category = Category.create({
# #                                title: "Test Category",
# #                                description: "BlahBluah Category"
# #                            })

# # Dir["C:\\Users\\Asus\\inno\\rent-system-couchdb\\app\\models\\*.rb"].each {|file| require file }
# # require 'subcategory.rb'
# # require_relative 'subcategory'

# @db = CouchRest.database!("http://admin:groot@127.0.0.1:5984/rent_couch_di")
# categories = ['Animals', 'Body parts', 'Clothes', 'Furniture', 'Musical instruments', 'Sport', 'Electric equipment', 'Other']
# # db.save_doc('name' => 'seed_test')

# # subcategory = Subcategory.create({
# #                                      title: "Teapots",
# #                                      description: "Here are some Teapots"
# #                                  })
# number_of_categories = categories.length
# number_of_users = 1000
# number_of_orders = 1000
# number_of_items = 10000 - number_of_categories - number_of_users - number_of_orders

# require_relative 'subcategory'
# require_relative 'user'
# require_relative 'item'
# require_relative 'order'


# def generate_categories(categories)
# 	categories_ids = Array.new
# 	categories.each do |category|
# 		categories_ids << @db.save_doc('type' => 'Subcategory', 
# 			'title' => category, 
# 			'description' => Faker::Lorem.sentence)['id']
# 	end
# 	return categories_ids
# end

# def generate_users(number_of_users)
# 	users_ids = Array.new
# 	number_of_users.times do
# 		uri = URI('http://localhost:3000/users')
# 		http = Net::HTTP.new(uri.host, uri.port)
# 		req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
# 		password = Faker::Internet.password(8, 16)
# 		req.body = {'name' => Faker::Name.first_name,
# 					'surname' => Faker::Name.last_name,
# 					'username' => Faker::Internet.username(5..8),
# 					'phone' => Faker::PhoneNumber.phone_number_with_country_code,
# 					'email' => Faker::Internet.email,
# 					'role_id' => 1,
# 					'password' => password,
# 					'password_confirmation' => password}.to_json
# 		res = http.request(req)
# 		users_ids << JSON.parse(res.body)['data']['_id']
# 	end
# 	return users_ids
# end

# # users_ids = generate_users(1)

# def generate_items(number_of_items, users_ids, categories_ids)
# 	items_ids = Array.new
# 	number_of_items.times do
# 		user_id = users_ids.sample
# 		category_id = categories_ids.sample
# 		items_ids << @db.save_doc('type' => 'Item',
# 					 'title' => Faker::Book::title,
# 					 'description' => Faker::Book.author,
# 					 'price' => Faker::Number.number(3),
# 					 'duration' => (1 + rand(7)),
# 					 'subcategory_id' => category_id,
# 					 'user_id' => user_id,
# 					 'order_ids' => [])['id']
# 	end
# 	return items_ids
# end




# def generate_orders(number_of_orders, users_ids, items_ids)
# 	number_of_orders.times do
# 		user_id = users_ids.sample
# 		item_id = items_ids.sample
# 		@db.save_doc('type' => 'Order',
# 					'status' => 1 + rand(8),
# 					'user_id' => user_id,
# 					'item_id' => item_id,
# 					'duration' => 1 + rand(4),
# 					'description' => Faker::Lorem.sentence
# 		)
# 	end
# end

# def generate_admin()
# 	uri = URI('http://localhost:3000/users')
# 	http = Net::HTTP.new(uri.host, uri.port)
# 	req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
# 	req.body = {'name' => 'Alexey',
# 				'surname' => 'Kanatov',
# 				'username' => 'kanatov_db_one_love',
# 				'phone' => '8 800 555 35 35',
# 				'email' => 'k@me.ru',
# 				'role_id' => 2,
# 				'password' => '1',
# 				'password_confirmation' => '1'}.to_json
# 	res = http.request(req)
# end

# def generate_admin2()
# 	uri = URI('http://localhost:3000/users')
# 	http = Net::HTTP.new(uri.host, uri.port)
# 	req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
# 	req.body = {'name' => 'Alex',
# 				'surname' => 'Kanatov',
# 				'username' => 'kanatov_db_one_love',
# 				'phone' => '8 800 555 35 35',
# 				'email' => 'ka@me.ru',
# 				'role_id' => 2,
# 				'password' => '1',
# 				'password_confirmation' => '1'}.to_json
# 	res = http.request(req)
# end

# def generate_example_users_and_their_stuff()
# 	uri = URI('http://localhost:3000/users')
# 	http = Net::HTTP.new(uri.host, uri.port)
# 	req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
# 	# Create user Rishat

# 	req.body = {'name' => 'Rishat',
# 				'surname' => 'Rizvanov',
# 				'username' => 'reshreshus',
# 				'phone' => '8 800 555 35 35',
# 				'email' => 'r.rizvanov@innopolis.ru',
# 				'role_id' => 1,
# 				'password' => '1',
# 				'password_confirmation' => '1'}.to_json
# 	res = http.request(req)
# 	# puts JSON.pretty_generate(JSON.parse(res.body))
# 	rishat_id = JSON.parse(res.body)['data']['_id']
# 	puts rishat_id
# 	# Create user Igor 
# 	req.body = {'name' => 'Igor',
# 				'surname' => 'Rizvanov',
# 				'username' => 'vakhula',
# 				'phone' => '8 800 555 35 35',
# 				'email' => 'i.vakhula@innopolis.ru',
# 				'role_id' => 1,
# 				'password' => '1',
# 				'password_confirmation' => '1'}.to_json
# 	res = http.request(req)
# 	igor_id = JSON.parse(res.body)['data']['_id']
# 	# Create user Sergey
# 	req.body = {'name' => 'Sergey',
# 				'surname' => 'Markin',
# 				'username' => 'markin',
# 				'phone' => '8 800 555 35 35',
# 				'email' => 's.markinv@innopolis.ru',
# 				'role_id' => 1,
# 				'password' => '1',
# 				'password_confirmation' => '1'}.to_json
# 	res = http.request(req)
# 	sergey_id = JSON.parse(res.body)['data']['_id']
	
# 	category_id = @db.save_doc('type' => 'Subcategory', 
# 			'title' => 'Example subcategory', 
# 			'description' => '___')['id']

# 	items_ids = Array.new

# 	i = 1
# 	2.times do
# 		items_ids << @db.save_doc('type' => 'Item',
# 			 'title' => 'Rishat\s item # ' + i.to_s,
# 			 'description' => '___',
# 			 'price' => (i*100).to_s,
# 			 'duration' => (1 + rand(7)),
# 			 'subcategory_id' => category_id,
# 			 'user_id' => rishat_id)['id']
# 		i = i + 1
# 	end

# 	orders_ids = Array.new
# 	orders_ids << @db.save_doc('type' => 'Order',
# 				'status' => 1 + rand(8),
# 				'user_id' => igor_id,
# 				'item_id' => items_ids[0],
# 				'duration' => 1 + rand(4),
# 				'description' => 'Igor rents Rishat\'s item'
# 	)['id']

# 	orders_ids << @db.save_doc('type' => 'Order',
# 				'status' => 1 + rand(8),
# 				'user_id' => sergey_id,
# 				'item_id' => items_ids[1],
# 				'duration' => 1 + rand(4),
# 				'description' => 'Igor rents Rishat\'s item'
# 	)['id']
# 	return [items_ids, orders_ids]
# end

# # categories_ids = generate_categories(categories)
# # users_ids = generate_users(number_of_users)
# # items_ids = generate_items(number_of_items, users_ids, categories_ids)
# # generate_orders(number_of_orders, users_ids, items_ids)

# # generate_admin()
# # example_items_ids = generate_example_users_and_their_stuff()
# # p example_items_ids
# # generate_admin2()