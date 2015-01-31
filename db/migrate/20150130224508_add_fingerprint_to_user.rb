class AddFingerprintToUser < ActiveRecord::Migration
  def change
    add_column :users, :fingerprint, :string
  end
end
