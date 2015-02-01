# 國父紀念館：25.039907,121.560296
# 忠孝復興站：25.041629,121.543767
# 市政府站：25.041171,121.565227
# 京華城：25.033254,121.543565
# 大安站：25.047848,121.561924
# 公館捷運站：25.014907,121.534215
# 古亭捷運站：25.026356,121.522872
# 台電大樓站：25.020724,121.528167
# 西門站：25.04209,121.508303
# 中山站：25.0527628,121.514061
# 民權西路站：25.062905,121.519319
# 南京復興站：25.052317,121.544011
# 中山國中站：25.060848,121.544226

API_KEY = 'AIzaSyC0EzNz2U6RSFjGK6EEBFqu-GX5GsEC9zY'

namespace :demo do
  desc 'import restaurants'
  task :restaurants => :environment do
    locations = [
      {lat: 25.039907, lng: 121.560296},
      {lat: 25.041629, lng: 121.543767},
      {lat: 25.041171, lng: 121.565227},
      {lat: 25.033254, lng: 121.561924},
      {lat: 25.047848, lng: 121.561924},
      {lat: 25.014907, lng: 121.534215},
      {lat: 25.026356, lng: 121.522872},
      {lat: 25.020724, lng: 121.528167},
      {lat: 25.04209,  lng: 121.508303},
      {lat: 25.0527628,lng: 121.514061},
      {lat: 25.062905, lng: 121.519319},
      {lat: 25.052317, lng: 121.544011},
      {lat: 25.060848, lng: 121.544226},
    ]

    @client = GooglePlaces::Client.new(API_KEY)

    locations.each do |location|
      spots = @client.spots(location[:lat], location[:lng],
        types: 'restaurant', radius: 500, language: 'zh-TW')

      spots.each do |spot|
        if !Restaurant.find_by_name(spot['name']) and spot['rating'] != nil and spot.photos[0]
          Restaurant.create({
              name:      spot['name'],
              latitude:  spot['lat'],
              longitude: spot['lng'],
              photo:     spot.photos[0] ? spot.photos[0].fetch_url(800) : nil,
              address:   spot['vicinity'],
              rating:    spot['rating']
            })
        end
        puts spot['name']
        puts '-'
      end
    end
  end

  desc 'clean restaurants'
  task :clean_restaurants => :environment do
    Restaurant.all.each do |r|
      if !r.photo
        puts "Delete restaurant: #{r.id}"
        r.delete
      end
    end
  end

  desc 'generate users'
  task :users => :environment do
    User.destroy_all
    10.times do
      password = Faker::Internet.password
      User.create({
          name:  Faker::Name.name,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        })
    end
  end

  desc 'generate dishes'
  task :dishes => :environment do
    Dish.delete_all

    Restaurant.all.shuffle.each do |r|
      begin
        user = User.all.shuffle.first
        dish = Dish.new({
          store_name: r.name,
          user_id: user.id
        })
        dish.remote_photo_url = r.photo
        dish.save

        puts "#{dish.id}"
      rescue
        puts 'drop'
      end
    end
  end

  desc 'generate avatar'
  task :user_avatar => :environment do
    User.all.each do |u|
      u.create_avatar
      puts u.id
    end
  end
end
