class CreatePrivateFolders < ActiveRecord::Migration[5.0]
  def change
    create_table :private_folders do |t|
      t.string :name
      t.integer :parent_id
      t.string :full_path
      t.integer :owner_id

      t.timestamps
    end
  end
end
