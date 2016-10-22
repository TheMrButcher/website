class AddIndexPanoramaIdAndIdxToPanoVersions < ActiveRecord::Migration[5.0]
  def change
    add_index :private_pano_versions, [:panorama_id, :idx], unique: true
  end
end
