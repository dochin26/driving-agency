class Customer < ApplicationRecord
  # Associations
  has_many :driving_records, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true

  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }
end
