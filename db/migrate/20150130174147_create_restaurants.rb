class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.string :photo
      t.string :address
      t.string :rating

      t.timestamps null: false
    end
  end
end
