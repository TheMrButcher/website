class AddIdxToPrivatePanoVersion < ActiveRecord::Migration[5.0]
  def change
    add_column :private_pano_versions, :idx, :integer
    add_index :private_pano_versions, :idx
  end
end
