json.array!(@dishes) do |dish|
  json.extract! dish, :id, :store_name, :photo, :description, :latitude, :longitude, :user_id
  json.url dish_url(dish, format: :json)
end
