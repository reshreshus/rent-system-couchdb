require 'couchrest'
require 'restclient'
require 'json'
# server = CouchRest.new           # assumes localhost by default!

# In principle all we need is a way to work with HTTP queries
# puts RestClient.get("http://127.0.0.1:5984/_all_dbs")

# But we need something more convenient. There are 2 ways
# Fitst - CouchRest Model gem
# Second, which will is shown below is uing CouchRest
db = CouchRest.database!("http://admin:groot@127.0.0.1:5984/mycompany")

design = db.get("_design/demo_view")
db.delete_doc(design)
# We can create a view in Fauxton or in code by making a design document
design = {
      "_id" => "_design/demo_view", 
      :views => {
        :all_docs => {
          :map => "function(doc){ emit(doc.key,doc)}"
          }
        }
      }
# I already made it before, let's fetch it and use for other reasons
# design = db.get("_design/demo_view")
 # design['views']['all_docs'] = {
          # :map => "function(doc){ emit(doc.key,doc)}" # JavaScript function here
          # }

db.save_doc(design)

all_docs = db.view('demo_view/all_docs')['rows']
	
puts JSON.pretty_generate(all_docs)
