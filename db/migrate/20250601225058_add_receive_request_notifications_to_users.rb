class AddReceiveRequestNotificationsToUsers < ActiveRecord::Migration[7.1]
  def change
      add_column :users, :receive_request_notifications, :boolean, default: false, null: false
    end
end
