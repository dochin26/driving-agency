class Vehicle < ApplicationRecord
  # Associations
  has_many :driving_records, dependent: :restrict_with_error

  # Validations
  validates :vehicle_number, presence: true, uniqueness: true
end
