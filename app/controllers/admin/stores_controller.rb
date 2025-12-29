module Admin
  class StoresController < BaseController
    before_action :set_store, only: [ :show, :edit, :update, :destroy ]

    def index
      @stores = Store.all.order(:name)
    end

    def show
    end

    def new
      @store = Store.new
    end

    def create
      @store = Store.new(store_params)

      respond_to do |format|
        if @store.save
          format.html { redirect_to admin_stores_path, notice: "店舗を登録しました。" }
          format.turbo_stream { redirect_to admin_stores_path, notice: "店舗を登録しました。" }
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
        if @store.update(store_params)
          format.html { redirect_to admin_stores_path, notice: "店舗を更新しました。" }
          format.turbo_stream { redirect_to admin_stores_path, notice: "店舗を更新しました。" }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @store.destroy

      respond_to do |format|
        format.html { redirect_to admin_stores_path, notice: "店舗を削除しました。" }
        format.turbo_stream { redirect_to admin_stores_path, notice: "店舗を削除しました。" }
      end
    end

    private

    def set_store
      @store = Store.find(params[:id])
    end

    def store_params
      params.require(:store).permit(:name, :address, :latitude, :longitude)
    end
  end
end
