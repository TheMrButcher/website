class AddIndexToUsersName < ActiveRecord::Migration[5.0]
  def change
    add_index :private_users, :name, unique: true
  end
end
