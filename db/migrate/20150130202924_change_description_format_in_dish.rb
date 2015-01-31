class ChangeDescriptionFormatInDish < ActiveRecord::Migration
  def up
    change_column :dishes, :description, :text
  end

  def down
    change_column :dishes, :description, :string
  end
end
