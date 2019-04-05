require 'couchrest_model'

class User < CouchRest::Model::Base
	property :email,      String
	property :password,      String
	property :username,      String
	property :name,      String
	property :surname,      String
	property :phone,      String
	property :surname,      String
	property :role_id,      Integer

	property :password_digest,		String

	#  With timestamps! we are telling the model to create autogenerated fields for created_at and updated_at.
	timestamps!


	design do
		view :by_name
	end

	# has_many :items, dependent: :destroy
	# TODO: does has_sec	ure_password work with couchdb model?
	# has_secure_password

 	validates_presence_of :email, :name, :surname, :password_digest, :role_id
 	# validates_presence_of :email, :name, :surname, :password_digest, :role_id
end