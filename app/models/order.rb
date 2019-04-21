require 'couchrest_model'
class Order < CouchRest::Model::Base
	# property :id,	Integer
	property :description,	String
	property :status,      Integer
	property :duration,  Integer

	timestamps!

	belongs_to :item
  	belongs_to :user


	validates_presence_of :item_id, :user_id, :duration, :status, :description
	# validates_presence_of :duration, :status, :description

	# item:references user:references
	# belongs_to works with couchrest_model

  	design do
		# view :by_id
  		view :by_user_id
  		view :by_item_id
  		view :get_all_orders,
		 :map =>
			 "function(doc) {
		          if (doc['type'] == 'item' && doc.orders) {
		            doc.orders.forEach(function(order){
		              emit(doc.order, 1);
		            });
		          }
	        }"	
  	end
end
