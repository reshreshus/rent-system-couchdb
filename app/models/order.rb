require 'couchrest_model'
class Order < CouchRest::Model::Base
	property :description,	String
	property :status,      Integer
	property :duration,  Integer


	# validates_presence_of :item_id, :user_id, :duration, :status, :description
	validates_presence_of :duration, :status, :description

	# item:references user:references
	# belongs_to works with couchrest_model
	belongs_to :item
  	belongs_to :user

  	design do
  		view :by_status
  	end
end
