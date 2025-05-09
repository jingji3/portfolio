class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[privacy_policy terms_of_use]

  def privacy_policy; end

  def terms_of_use; end
end
