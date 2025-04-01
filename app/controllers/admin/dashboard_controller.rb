module Admin
  class DashboardController < ApplicationController
    # Administrateのベースコントローラーではなく、標準のApplicationControllerを継承
    include Sorcery::Controller # 認証を使用するなら
    before_action :require_login
    before_action :require_admin

    layout "admin" # 管理画面用のレイアウトを使用

    def index
      @user_count = User.count
      @admin_count = User.where(role: 1).count
      @recent_users = User.order(created_at: :desc).limit(5)
    end

    private

    def require_admin
      redirect_to root_path, alert: "管理者権限が必要です" unless current_user&.admin?
    end

    def require_login
      redirect_to login_path, alert: "ログインしてください" unless current_user
    end
  end
end
