class AddConfigIdToPrivatePanoVersion < ActiveRecord::Migration[5.0]
  def change
    add_column :private_pano_versions, :config_id, :integer
  end
end
