class ChangeVehicleIdToNullableInDrivingRecords < ActiveRecord::Migration[8.1]
  def change
    change_column_null :driving_records, :vehicle_id, true
  end
end
