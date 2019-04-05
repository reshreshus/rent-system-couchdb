require 'couchrest_model'

class Item < CouchRest::Model::Base
	property :title,      String
	property :description,	String
	property :price,      String
	property :duration,   Integer
	property :subcategory, String

	timestamps!

	design do
		view :by_name
	end

	#validates_presence_of :user_id, :title, :description, :price, :duration#, :subcategory_id
	# validates_presence_of :title, :description, :price, :duration
	#user:references subcategory:references
end
