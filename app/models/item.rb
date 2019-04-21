require 'couchrest_model'

class Item < CouchRest::Model::Base
	property :title,      String
	property :description,	String
	property :price,      String
	property :duration,   Integer

	property :image,	String

	belongs_to :subcategory
	belongs_to :user

	collection_of :orders

	timestamps!

	design do
		view :by_name
		view :by_user_id
		view :by_subcategory_id
	end

	validates_presence_of :user_id, :title, :description, :price, :duration, :subcategory_id
	# validates_presence_of :title, :description, :price, :duration
	#user:references subcategory:references
end
