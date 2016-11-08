class AddTitleToPrivateFoldersAndPanoramas < ActiveRecord::Migration[5.0]
  def change
    add_column :private_folders, :title, :string
    add_column :private_panoramas, :title, :string
  end
end
