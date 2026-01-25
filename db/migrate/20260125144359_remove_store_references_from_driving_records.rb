class RemoveStoreReferencesFromDrivingRecords < ActiveRecord::Migration[8.1]
  def change
    # store_idカラムとインデックスを削除
    remove_index :driving_records, :store_id if index_exists?(:driving_records, :store_id)
    remove_column :driving_records, :store_id, :bigint

    # store_nameは手入力用に残す
  end
end
