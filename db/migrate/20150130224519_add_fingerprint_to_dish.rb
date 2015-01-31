class AddFingerprintToDish < ActiveRecord::Migration
  def change
    add_column :dishes, :fingerprint, :string
  end
end
