class AddStoresPanoramasToPrivateFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :private_folders, :stores_panoramas, :boolean, default: false
  end
end
