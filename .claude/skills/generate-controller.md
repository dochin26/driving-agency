# コントローラー生成

docs/screen_design.md の画面設計を参照して、Railsのコントローラーを生成してください。

## 要件

1. **RESTful設計**
   - index, show, new, create, edit, update, destroy
   - 必要に応じてカスタムアクション（confirm など）

2. **権限チェック**
   - before_action で認証チェック
   - ドライバーは自分の記録のみ編集可
   - 管理者は全て編集可

3. **Strong Parameters**
   - permitで許可するパラメータを明示

4. **フラッシュメッセージ**
   - 成功・失敗時のメッセージ

5. **リダイレクト**
   - 適切な画面へリダイレクト

6. **エラーハンドリング**
   - rescue_from で例外処理

## 出力形式

各コントローラーファイルをRails形式で生成してください。

例：
```ruby
class DrivingRecordsController < ApplicationController
  before_action :authenticate_driver!
  before_action :set_driving_record, only: [:show, :edit, :update, :destroy]
  before_action :authorize_driver!, only: [:edit, :update, :destroy]

  def index
    @driving_records = DrivingRecord.includes(:driver, :vehicle, :customer)
                                    .order(departed_at: :desc)
                                    .page(params[:page])
  end

  def new
    @driving_record = DrivingRecord.new
  end

  def create
    @driving_record = current_driver.driving_records.build(driving_record_params)
    @driving_record.created_by = current_driver

    if @driving_record.save
      redirect_to root_path, notice: '登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_driving_record
    @driving_record = DrivingRecord.find(params[:id])
  end

  def authorize_driver!
    unless current_driver.admin? || @driving_record.driver == current_driver
      redirect_to root_path, alert: 'この操作は許可されていません'
    end
  end

  def driving_record_params
    params.require(:driving_record).permit(:departed_at, :store_name, ...)
  end
end
```
