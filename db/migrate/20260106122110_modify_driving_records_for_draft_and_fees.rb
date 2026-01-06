class ModifyDrivingRecordsForDraftAndFees < ActiveRecord::Migration[8.1]
  def change
    # 経由地カラムを削除（waypointsテーブルに移行）
    remove_column :driving_records, :waypoint_location, :string
    remove_column :driving_records, :waypoint_latitude, :decimal
    remove_column :driving_records, :waypoint_longitude, :decimal

    # 下書き保存用のカラムを追加
    add_column :driving_records, :status, :integer, default: 0, null: false
    add_column :driving_records, :completed_at, :datetime

    # 金額詳細カラムを追加
    add_column :driving_records, :fare_amount, :integer, default: 0
    add_column :driving_records, :highway_fee, :integer, default: 0
    add_column :driving_records, :parking_fee, :integer, default: 0
    add_column :driving_records, :other_fee, :integer, default: 0

    # 店舗・顧客の手入力対応
    change_column_null :driving_records, :store_id, true
    add_column :driving_records, :customer_name, :string

    # インデックス追加
    add_index :driving_records, :status
  end
end
