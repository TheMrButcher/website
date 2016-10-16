class AddIndexToFoldersParentId < ActiveRecord::Migration[5.0]
  def change
    add_index :private_folders, :parent_id
  end
end
