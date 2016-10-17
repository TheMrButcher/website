class AddPublicToPrivateFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :private_folders, :public, :boolean, default: false
  end
end
