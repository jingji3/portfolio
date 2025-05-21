class AddYoutubeStartTimeToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :youtube_start_time, :integer
  end
end
