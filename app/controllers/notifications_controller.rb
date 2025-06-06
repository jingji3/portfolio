class NotificationsController < ApplicationController
  before_action :require_login

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    head :ok
  end
end
