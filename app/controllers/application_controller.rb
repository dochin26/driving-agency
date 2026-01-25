class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  # Deviseのパラメータ許可設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :employee_number ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :employee_number ])
  end

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
