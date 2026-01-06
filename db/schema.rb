# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_06_122110) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_customers_on_name"
  end

  create_table "daily_report_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "end_hour", null: false
    t.integer "start_hour", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_drivers_on_email", unique: true
  end

  create_table "driving_records", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "arrival_datetime", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "customer_name"
    t.datetime "departure_datetime", null: false
    t.decimal "departure_latitude", precision: 10, scale: 7
    t.string "departure_location"
    t.decimal "departure_longitude", precision: 10, scale: 7
    t.string "destination", null: false
    t.decimal "destination_latitude", precision: 10, scale: 7
    t.decimal "destination_longitude", precision: 10, scale: 7
    t.decimal "distance", precision: 8, scale: 2, null: false
    t.bigint "driver_id", null: false
    t.integer "fare_amount", default: 0
    t.integer "highway_fee", default: 0
    t.text "notes"
    t.integer "other_fee", default: 0
    t.integer "parking_fee", default: 0
    t.integer "status", default: 0, null: false
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.index ["customer_id"], name: "index_driving_records_on_customer_id"
    t.index ["departure_datetime"], name: "index_driving_records_on_departure_datetime"
    t.index ["driver_id"], name: "index_driving_records_on_driver_id"
    t.index ["status"], name: "index_driving_records_on_status"
    t.index ["store_id"], name: "index_driving_records_on_store_id"
    t.index ["vehicle_id"], name: "index_driving_records_on_vehicle_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stores_on_name"
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_info"
    t.string "vehicle_number", null: false
    t.index ["vehicle_number"], name: "index_vehicles_on_vehicle_number", unique: true
  end

  create_table "waypoints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "driving_record_id", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.string "location", null: false
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "sequence", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_record_id", "sequence"], name: "index_waypoints_on_driving_record_id_and_sequence"
    t.index ["driving_record_id"], name: "index_waypoints_on_driving_record_id"
  end

  add_foreign_key "driving_records", "customers"
  add_foreign_key "driving_records", "drivers"
  add_foreign_key "driving_records", "stores"
  add_foreign_key "driving_records", "vehicles"
  add_foreign_key "waypoints", "driving_records"
end
