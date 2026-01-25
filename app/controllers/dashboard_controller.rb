class DashboardController < ApplicationController
  before_action :authenticate_driver!

  def index
    @recent_records = DrivingRecord.completed_records.recent.limit(5)
    @draft_records = current_driver.driving_records.drafts
                                   .where("created_at >= ?", 7.days.ago)
                                   .order(updated_at: :desc)
  end
end
