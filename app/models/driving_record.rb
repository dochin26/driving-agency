class DrivingRecord < ApplicationRecord
  # Attribute types
  attribute :status, :integer, default: 0

  # Enums
  enum :status, { draft: 0, completed: 1 }

  # Associations
  belongs_to :driver
  belongs_to :vehicle, optional: true
  belongs_to :customer, optional: true
  has_many :waypoints, -> { order(:sequence) }, dependent: :destroy

  # Nested attributes for waypoints
  accepts_nested_attributes_for :waypoints, allow_destroy: true, reject_if: proc { |attributes| attributes["location"].blank? }

  # Validations
  validates :departure_datetime, presence: true
  validates :destination, presence: true, if: :completed?
  validates :arrival_datetime, presence: true, if: :completed?
  validates :distance, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :completed?
  validates :vehicle_id, presence: true, if: :completed?
  validates :waypoints, length: { maximum: 10 }

  # 金額のバリデーション
  validates :fare_amount, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :highway_fee, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :parking_fee, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :other_fee, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true

  # Callbacks
  before_save :calculate_total_amount
  before_save :set_completed_at, if: :will_save_change_to_status?

  # Scopes
  scope :by_date, ->(date) { where("departure_datetime >= ? AND departure_datetime < ?", date.beginning_of_day, date.end_of_day) }
  scope :by_vehicle, ->(vehicle_id) { where(vehicle_id: vehicle_id) }
  scope :by_driver, ->(driver_id) { where(driver_id: driver_id) }
  scope :recent, -> { order(departure_datetime: :desc) }
  scope :drafts, -> { where(status: :draft) }
  scope :completed_records, -> { where(status: :completed) }

  # 合計金額を計算
  def total_amount
    (fare_amount || 0) + (highway_fee || 0) + (parking_fee || 0) + (other_fee || 0)
  end

  # 顧客名を取得（顧客IDがあればその名前、なければ手入力の顧客名）
  def customer_display_name
    customer&.name || customer_name
  end

  private

  def calculate_total_amount
    self.amount = total_amount
  end

  def set_completed_at
    if status == "completed" && completed_at.nil?
      self.completed_at = Time.current
    end
  end
end
