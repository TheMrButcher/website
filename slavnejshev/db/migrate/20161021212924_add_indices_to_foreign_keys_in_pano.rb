class AddIndicesToForeignKeysInPano < ActiveRecord::Migration[5.0]
  def change
    add_index :private_panoramas, :folder_id
    add_index :private_pano_versions, :panorama_id
  end
end
