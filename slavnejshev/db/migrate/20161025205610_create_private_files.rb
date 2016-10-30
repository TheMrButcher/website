class CreatePrivateFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :private_files do |t|
      t.string :original_name
      t.string :key
      t.integer :datum_id

      t.timestamps
    end
    add_index :private_files, :datum_id
    add_index :private_files, :key, unique: true
  end
end
