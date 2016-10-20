class AddIndexToPrivatePanoramasFullPath < ActiveRecord::Migration[5.0]
  def change
    add_index :private_panoramas, :full_path, unique: true
  end
end
