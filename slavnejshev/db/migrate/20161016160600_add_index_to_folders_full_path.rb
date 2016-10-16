class AddIndexToFoldersFullPath < ActiveRecord::Migration[5.0]
  def change
    add_index :private_folders, :full_path, unique: true
  end
end
