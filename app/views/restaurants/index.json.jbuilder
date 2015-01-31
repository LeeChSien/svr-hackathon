json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :latitude, :longitude, :photo, :address, :rating
  json.url restaurant_url(restaurant, format: :json)
end
