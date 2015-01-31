class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :store_name
      t.string :photo
      t.string :description
      t.string :latitude
      t.string :longitude
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
