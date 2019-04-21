require 'couchrest_model'

class Cat < CouchRest::Model::Base
  property :name,        String
  property :last_fed_at, Time
  property :awake,       TrueClass, :default => false
end

# Assign values to the properties on instantiation
# @cat = Cat.new(:name => 'Felix', :last_fed_at => 10.minutes.ago)

# # Access the values
# @cat.name   #=> 'Felix'
# @cat.last_fed_at   #=> Time.parse('2011-04-21T10:32:00Z')

# # @cat = Cat.find(@cat.id)
# @cat.attributes = { :name => "Felix", :birthday => Date.new(2011, 1, 1) }

# puts @cat.name

# @cat.save