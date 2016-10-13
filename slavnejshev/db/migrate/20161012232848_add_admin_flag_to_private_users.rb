class AddAdminFlagToPrivateUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :private_users, :admin, :boolean, default: false
  end
end
