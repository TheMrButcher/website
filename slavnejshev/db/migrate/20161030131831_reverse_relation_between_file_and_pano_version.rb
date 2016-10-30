class ReverseRelationBetweenFileAndPanoVersion < ActiveRecord::Migration[5.0]
  def change
    remove_column :private_pano_versions, :config_id
    add_column :private_files, :storage_id, :integer
    add_column :private_files, :storage_type, :string
    add_column :private_files, :file_type, :integer
    add_index :private_files, [:storage_id, :storage_type]
  end
end
