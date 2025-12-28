class DrivingRecord < ApplicationRecord
  # Associations
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :store
  belongs_to :customer, optional: true

  # Validations
  validates :departure_datetime, presence: true
  validates :arrival_datetime, presence: true
  validates :destination, presence: true
  validates :distance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  # Scopes
  scope :by_date, ->(date) { where("departure_datetime >= ? AND departure_datetime < ?", date.beginning_of_day, date.end_of_day) }
  scope :by_vehicle, ->(vehicle_id) { where(vehicle_id: vehicle_id) }
  scope :by_driver, ->(driver_id) { where(driver_id: driver_id) }
  scope :recent, -> { order(departure_datetime: :desc) }
end
