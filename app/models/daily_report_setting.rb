class DailyReportSetting < ApplicationRecord
  # Validations
  validates :start_hour, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 }
  validates :end_hour, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 28 }
end
