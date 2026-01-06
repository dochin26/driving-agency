class CreateWaypoints < ActiveRecord::Migration[8.1]
  def change
    create_table :waypoints do |t|
      t.references :driving_record, null: false, foreign_key: true
      t.integer :sequence, null: false
      t.string :location, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end

    add_index :waypoints, [ :driving_record_id, :sequence ]
  end
end
