class DrivingRecordsController < ApplicationController
  before_action :authenticate_driver!
  before_action :set_driving_record, only: [ :show, :edit, :update, :destroy ]

  def index
    @driving_records = DrivingRecord.includes(:driver, :vehicle, :store, :customer)
                                     .recent
                                     .page(params[:page])
                                     .per(20)
  end

  def show
  end

  def new
    @driving_record = DrivingRecord.new
    @driving_record.departure_datetime = Time.current
    @driving_record.driver_id = current_driver.id
  end

  def create
    @driving_record = DrivingRecord.new(driving_record_params)
    @driving_record.driver_id = current_driver.id

    respond_to do |format|
      if @driving_record.save
        format.html { redirect_to driving_records_path, notice: "運転記録を登録しました。" }
        format.turbo_stream { redirect_to driving_records_path, notice: "運転記録を登録しました。" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @driving_record.update(driving_record_params)
        format.html { redirect_to driving_record_path(@driving_record), notice: "運転記録を更新しました。" }
        format.turbo_stream { redirect_to driving_record_path(@driving_record), notice: "運転記録を更新しました。" }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @driving_record.destroy

    respond_to do |format|
      format.html { redirect_to driving_records_path, notice: "運転記録を削除しました。" }
      format.turbo_stream { redirect_to driving_records_path, notice: "運転記録を削除しました。" }
    end
  end

  private

  def set_driving_record
    @driving_record = DrivingRecord.find(params[:id])
  end

  def driving_record_params
    params.require(:driving_record).permit(
      :departure_datetime,
      :departure_location,
      :departure_latitude,
      :departure_longitude,
      :store_id,
      :waypoint_location,
      :waypoint_latitude,
      :waypoint_longitude,
      :arrival_datetime,
      :destination,
      :destination_latitude,
      :destination_longitude,
      :distance,
      :amount,
      :vehicle_id,
      :customer_id,
      :notes
    )
  end
end
