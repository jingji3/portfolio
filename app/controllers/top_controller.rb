class TopController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  include YoutubeHelper
  def index
    @posts = Post.order(created_at: :desc).limit(1)
    @teams = Team.joins(:team_ratings)
                  .select("teams.*, AVG(team_ratings.rating) as average_rating, COUNT(team_ratings.id) as ratings_count")
                  .group("teams.id")
                  .includes(:characters).order(created_at: :desc).limit(3)

    if params[:tag].present?
      @posts = @posts.joins(:tags).where(tags: { name: params[:tag].downcase })
    end

    @posts = @posts.distinct.page(params[:page]).per(9)

    # YouTube情報の取得
    @youtube_info = {}
    youtube_service = YoutubeService.new

    # 動画情報の取得
    @posts.each do |post|
      video_id = extract_youtube_id(post.video_url)

      if video_id
        video_data = youtube_service.get_video_info(video_id)

        if video_data&.items.any?
          channel_id = video_data.items.first.snippet.channel_id
          channel_data = youtube_service.get_channel_info(channel_id)

          @youtube_info[post.id] = {
            video_data: video_data,
            channel_data: channel_data
          }
        end
      end
    end
  end
end
