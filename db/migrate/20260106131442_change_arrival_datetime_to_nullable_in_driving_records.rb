class ChangeArrivalDatetimeToNullableInDrivingRecords < ActiveRecord::Migration[8.1]
  def change
    change_column_null :driving_records, :arrival_datetime, true
    change_column_null :driving_records, :destination, true
    change_column_null :driving_records, :distance, true
  end
end
