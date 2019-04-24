require 'couchrest_model'

class Subcategory < CouchRest::Model::Base
  	property :title,	String	
  	property :description,	String

  	timestamps!

 	validates_presence_of :title, :description
  	design do
		view :by_title
		view :by_title_and_description
	end
end