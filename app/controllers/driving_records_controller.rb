class DrivingRecordsController < ApplicationController
  before_action :authenticate_driver!
  before_action :set_driving_record, only: [ :show, :edit, :update, :destroy ]

  def index
    @driving_records = DrivingRecord.includes(:driver, :vehicle, :customer)
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

    # ボタンに応じてステータスを設定
    if params[:save_completed]
      @driving_record.status = :completed
    else
      @driving_record.status = :draft
    end

    respond_to do |format|
      if @driving_record.save
        message = @driving_record.completed? ? "運転記録を登録しました。" : "下書きを保存しました。"
        format.html { redirect_to driving_records_path, notice: message }
        format.json { render json: { id: @driving_record.id, message: message }, status: :created }
        format.turbo_stream { redirect_to driving_records_path, notice: message }
      else
        Rails.logger.error "Validation errors: #{@driving_record.errors.full_messages.join(', ')}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @driving_record.errors }, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    # ボタンに応じてステータスを設定
    if params[:save_completed]
      @driving_record.status = :completed
    elsif params[:save_draft]
      @driving_record.status = :draft
    end

    respond_to do |format|
      if @driving_record.update(driving_record_params)
        message = @driving_record.completed? ? "運転記録を更新しました。" : "下書きを保存しました。"
        format.html { redirect_to driving_record_path(@driving_record), notice: message }
        format.json { render json: { id: @driving_record.id, message: message }, status: :ok }
        format.turbo_stream { redirect_to driving_record_path(@driving_record), notice: message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @driving_record.errors }, status: :unprocessable_entity }
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

  def daily_report
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @vehicle_id = params[:vehicle_id]

    # 日報範囲設定を取得
    @setting = DailyReportSetting.first || DailyReportSetting.create(start_hour: 19, end_hour: 28)

    # 日報の開始・終了日時を計算
    start_datetime = @date.to_time.change(hour: @setting.start_hour)
    # end_hourが24以上の場合は翌日
    if @setting.end_hour >= 24
      end_datetime = (@date + 1.day).to_time.change(hour: @setting.end_hour - 24)
    else
      end_datetime = @date.to_time.change(hour: @setting.end_hour)
    end

    # 日報データを取得
    @records = DrivingRecord.includes(:driver, :vehicle, :customer)
                            .where(departure_datetime: start_datetime...end_datetime)

    @records = @records.where(vehicle_id: @vehicle_id) if @vehicle_id.present?
    @records = @records.order(:departure_datetime)

    # 合計値を計算
    @total_distance = @records.sum(:distance)
    @total_amount = @records.sum(:amount)

    @vehicles = Vehicle.all
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
      :departure_note,
      :arrival_datetime,
      :destination,
      :destination_latitude,
      :destination_longitude,
      :distance,
      :fare_amount,
      :highway_fee,
      :parking_fee,
      :other_fee,
      :vehicle_id,
      :customer_id,
      :customer_name,
      :notes,
      :status,
      waypoints_attributes: [ :id, :sequence, :location, :latitude, :longitude, :_destroy ]
    )
  end
end
