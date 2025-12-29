class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  # Admin権限チェック
  def authorize_admin!
    unless current_driver&.admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end

  # Turboリクエストの場合のリダイレクト処理
  def redirect_to_with_turbo(path, options = {})
    respond_to do |format|
      format.html { redirect_to path, options }
      format.turbo_stream { redirect_to path, options }
    end
  end
end
