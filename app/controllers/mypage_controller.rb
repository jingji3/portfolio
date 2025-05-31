class MypageController < ApplicationController
  include YoutubeHelper
  def index
    @user = current_user
    @active_tab = params[:tab] || 'dashboard'

    # タブごとに必要なデータを取得する
    case @active_tab
    when 'posts'
      @posts = current_user.posts.includes(:tags).order(created_at: :desc).page(params[:page]).per(9)

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
    when 'favorites'
      @favorite_posts = current_user.favorite_posts.order(created_at: :desc).page(params[:page]).per(9)

      # YouTube情報の取得
      @youtube_info = {}
      youtube_service = YoutubeService.new

      # 動画情報の取得
      @favorite_posts.each do |post|
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
    when 'team_ratings'
      @team_ratings = current_user.team_ratings.order(created_at: :desc).page(params[:page]).per(9)
    end
  end
end
