module Admin
  class DashboardController < ApplicationController
    # Administrateのベースコントローラーではなく、標準のApplicationControllerを継承
    include Sorcery::Controller # 認証を使用するなら
    before_action :require_login
    before_action :require_admin

    layout "admin" # 管理画面用のレイアウトを使用

    def index
      @user_count = User.count
      @post_count = Post.count
      @team_rating_count = TeamRating.count
      @team_count = Team.count
    end

    private

    def require_admin
      redirect_to root_path, alert: t("admin.dashboard.require_admin") unless current_user&.admin?
    end

    def require_login
      redirect_to login_path, alert: t("admin.dashboard.require_login") unless current_user
    end
  end
end
