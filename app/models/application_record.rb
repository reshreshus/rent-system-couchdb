require 'couchrest_model'
class ApplicationRecord < CouchRest::Model::Base
  self.abstract_class = true
end
