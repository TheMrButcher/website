class CreatePrivatePanoVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :private_pano_versions do |t|
      t.text :description
      t.integer :panorama_id

      t.timestamps
    end
  end
end
