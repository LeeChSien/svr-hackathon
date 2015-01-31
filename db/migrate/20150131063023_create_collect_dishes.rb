class CreateCollectDishes < ActiveRecord::Migration
  def change
    create_table :collect_dishes do |t|
      t.integer :dish_id
      t.integer :collection_id

      t.timestamps null: false
    end
  end
end
