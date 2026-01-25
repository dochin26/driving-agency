class DropStoresTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :stores do |t|
      t.string :name, null: false
      t.string :address
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index :name
    end
  end
end
