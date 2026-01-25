class AddStoreNameToDrivingRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :driving_records, :store_name, :string
  end
end
