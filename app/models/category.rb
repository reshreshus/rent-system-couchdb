require 'couchrest_model'
# load 'subcategory.rb'

class Subcategory
	include CouchRest::Model::Embeddable
  	property :title,	String
  	property :description,	String

  	# timestamps!

 	validates_presence_of :title, :description
  	# design do
		# view :by_title
	# end
end

class Category < CouchRest::Model::Base
	property :title,      String
	property :description,	String
	property :subcategories, Subcategory, :array => true

	timestamps!

	# when all are quiries they are sorted by name
  	design do
		view :by_name
	end
		
	validates_presence_of :title, :descriptions
end	
