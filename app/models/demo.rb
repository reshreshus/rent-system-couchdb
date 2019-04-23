require 'couchrest'
require 'restclient'
require 'json'
# server = CouchRest.new           # assumes localhost by default!

# In principle all we need is a way to work with HTTP queries
# puts RestClient.get("http://127.0.0.1:5984/_all_dbs")

# But we need something more convenient. There are 2 ways
# Fitst - CouchRest gem

# CouchRest Model gem

db = CouchRest.database!("http://admsin:groot@127.0.0.1:5984/mycompany")

# Save a document, with ID
db.save_doc('_id' => 'doc', 'name' => 'test')
# Fetch doc via ID
doc = db.get('doc')
# doc.inspect # #<CouchRest::Document _id: "doc", _rev: "1-defa304b36f9b3ef3ed606cc45d02fe2", name: "test", date: "2015-07-13">
puts JSON.pretty_generate(doc)

# Delete
db.delete_doc(doc)	