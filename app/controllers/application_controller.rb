class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger

  private

  def require_login
    return if current_user

    flash[:alert] = t('defaults.flash_message.require_login')
    redirect_to login_path
  end

  def not_authenticated
    redirect_to login_path
  end

  helper_method :user_signed_in?

  # ユーザーがログインしているかどうかを確認するメソッド
  def user_signed_in?
    !!current_user
  end
end
