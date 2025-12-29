class DashboardController < ApplicationController
  before_action :authenticate_driver!

  def index
    @recent_records = DrivingRecord.recent.limit(5)
  end
end
