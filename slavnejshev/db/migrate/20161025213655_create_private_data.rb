class CreatePrivateData < ActiveRecord::Migration[5.0]
  def change
    create_table :private_data do |t|
      t.string :path
      t.string :hash

      t.timestamps
    end
    add_index :private_data, :path, unique: true
    add_index :private_data, :hash, unique: true
  end
end
