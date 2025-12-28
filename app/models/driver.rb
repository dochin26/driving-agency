class Driver < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # Enums
  enum :role, { driver: 0, admin: 1 }

  # Associations
  has_many :driving_records, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :role, presence: true

  # Methods
  def admin?
    role == "admin"
  end
end
