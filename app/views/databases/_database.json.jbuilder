json.extract! database, :id, :name, :url, :port, :type, :password, :username, :created_at, :updated_at
json.url database_url(database, format: :json)
