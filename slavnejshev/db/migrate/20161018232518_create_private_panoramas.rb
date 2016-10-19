class CreatePrivatePanoramas < ActiveRecord::Migration[5.0]
  def change
    create_table :private_panoramas do |t|
      t.string :name
      t.text :description
      t.integer :folder_id
      t.string :full_path

      t.timestamps
    end
  end
end
