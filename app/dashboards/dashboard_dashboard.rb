require "administrate/base_dashboard"

class DashboardDashboard < Administrate::BaseDashboard
  # 最小限のダッシュボード定義
  ATTRIBUTE_TYPES = {}.freeze
  COLLECTION_ATTRIBUTES = [].freeze
  SHOW_PAGE_ATTRIBUTES = [].freeze
  FORM_ATTRIBUTES = [].freeze

  # 必須メソッド
  def display_resource(dashboard)
    "Dashboard"
  end
end
