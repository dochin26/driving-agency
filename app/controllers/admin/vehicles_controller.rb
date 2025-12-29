module Admin
  class VehiclesController < ApplicationController
    before_action :authenticate_driver!
    before_action :authorize_admin!
    before_action :set_vehicle, only: [ :show, :edit, :update, :destroy ]

    def index
      @vehicles = Vehicle.all.order(:vehicle_number)
    end

    def show
    end

    def new
      @vehicle = Vehicle.new
    end

    def create
      @vehicle = Vehicle.new(vehicle_params)

      respond_to do |format|
        if @vehicle.save
          format.html { redirect_to admin_vehicles_path, notice: "車両を登録しました。" }
          format.turbo_stream { redirect_to admin_vehicles_path, notice: "車両を登録しました。" }
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
        if @vehicle.update(vehicle_params)
          format.html { redirect_to admin_vehicles_path, notice: "車両を更新しました。" }
          format.turbo_stream { redirect_to admin_vehicles_path, notice: "車両を更新しました。" }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @vehicle.destroy

      respond_to do |format|
        format.html { redirect_to admin_vehicles_path, notice: "車両を削除しました。" }
        format.turbo_stream { redirect_to admin_vehicles_path, notice: "車両を削除しました。" }
      end
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:vehicle_number, :vehicle_info)
    end

    def authorize_admin!
      unless current_driver.admin?
        redirect_to root_path, alert: "管理者権限が必要です。"
      end
    end
  end
end
