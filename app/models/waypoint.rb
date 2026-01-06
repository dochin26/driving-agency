class Waypoint < ApplicationRecord
  belongs_to :driving_record

  validates :sequence, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :location, presence: true
  validates :latitude, numericality: { allow_nil: true }
  validates :longitude, numericality: { allow_nil: true }

  # 順序でソート
  default_scope -> { order(:sequence) }
end
