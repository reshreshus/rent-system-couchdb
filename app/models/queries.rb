# Queries
require_relative 'user'

# Just get all users sorted by email
# curl -X GET http://admin:groot@127.0.0.1:5984/_all_dbs

@users = User.all
# puts render json: {data: @users}

# All items I have (to give to others)
# https://localhost:3000/


# All orders I have (completed or any other status)
# All items I currently rent
# All my items that are currently rented by someone
# Geospatial search (?)
# 