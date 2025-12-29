module Admin
  class CustomersController < BaseController
    before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

    def index
      @customers = Customer.all.order(:name)
    end

    def show
    end

    def new
      @customer = Customer.new
    end

    def create
      @customer = Customer.new(customer_params)

      respond_to do |format|
        if @customer.save
          format.html { redirect_to admin_customers_path, notice: "顧客を登録しました。" }
          format.turbo_stream { redirect_to admin_customers_path, notice: "顧客を登録しました。" }
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
        if @customer.update(customer_params)
          format.html { redirect_to admin_customers_path, notice: "顧客を更新しました。" }
          format.turbo_stream { redirect_to admin_customers_path, notice: "顧客を更新しました。" }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @customer.destroy

      respond_to do |format|
        format.html { redirect_to admin_customers_path, notice: "顧客を削除しました。" }
        format.turbo_stream { redirect_to admin_customers_path, notice: "顧客を削除しました。" }
      end
    end

    private

    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :address, :latitude, :longitude, :phone, :notes)
    end
  end
end
