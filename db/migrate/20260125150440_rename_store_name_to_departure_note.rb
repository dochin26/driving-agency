class RenameStoreNameToDepartureNote < ActiveRecord::Migration[8.1]
  def change
    rename_column :driving_records, :store_name, :departure_note
  end
end
