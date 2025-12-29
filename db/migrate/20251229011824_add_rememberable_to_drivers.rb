class AddRememberableToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :remember_created_at, :datetime
  end
end
