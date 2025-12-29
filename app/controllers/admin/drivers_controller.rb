module Admin
  class DriversController < BaseController
    before_action :set_driver, only: [ :show, :edit, :update, :destroy ]

    def index
      @drivers = Driver.all.order(:name)
    end

    def show
    end

    def created
      @driver = Driver.find(params[:id])
      @generated_password = params[:password]
    end

    def new
      @driver = Driver.new
    end

    def create
      @driver = Driver.new(driver_params)
      # Deviseではランダムパスワードを生成し、後でドライバーに変更してもらう
      @generated_password = SecureRandom.hex(10)
      @driver.password = @generated_password
      @driver.password_confirmation = @generated_password

      if @driver.save
        redirect_to created_admin_driver_path(@driver, password: @generated_password)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        # パスワード更新の場合とそれ以外で処理を分ける
        if driver_params[:password].present?
          if @driver.update(driver_params)
            format.html { redirect_to admin_drivers_path, notice: "ドライバー情報を更新しました。" }
            format.turbo_stream { redirect_to admin_drivers_path, notice: "ドライバー情報を更新しました。" }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.turbo_stream { render :edit, status: :unprocessable_entity }
          end
        else
          # パスワードが空の場合はパスワード以外を更新
          if @driver.update_without_password(driver_params.except(:password, :password_confirmation))
            format.html { redirect_to admin_drivers_path, notice: "ドライバー情報を更新しました。" }
            format.turbo_stream { redirect_to admin_drivers_path, notice: "ドライバー情報を更新しました。" }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.turbo_stream { render :edit, status: :unprocessable_entity }
          end
        end
      end
    end

    def destroy
      if @driver.driving_records.exists?
        redirect_to admin_drivers_path, alert: "運転記録が紐づいているため削除できません。"
      else
        @driver.destroy
        respond_to do |format|
          format.html { redirect_to admin_drivers_path, notice: "ドライバーを削除しました。" }
          format.turbo_stream { redirect_to admin_drivers_path, notice: "ドライバーを削除しました。" }
        end
      end
    end

    private

    def set_driver
      @driver = Driver.find(params[:id])
    end

    def driver_params
      params.require(:driver).permit(:name, :email, :role, :password, :password_confirmation)
    end
  end
end
