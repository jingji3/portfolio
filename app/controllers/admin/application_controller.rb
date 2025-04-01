module Admin
  class ApplicationController < Administrate::ApplicationController
    include Sorcery::Controller
    include AdministrateRansackSearch

    before_action :require_login
    before_action :require_admin

    layout "admin"

    def require_admin
      redirect_to root_path, alert: "管理者権限が必要です" unless current_user.admin?
    end

    def require_login
      unless current_user
        redirect_to login_path, alert: "ログインしてください"
      end
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
