class FixHashColumnNameInPrivateData < ActiveRecord::Migration[5.0]
  def change
    rename_column :private_data, :hash, :datum_hash
  end
end
