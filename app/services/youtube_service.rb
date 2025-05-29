require 'google/apis/youtube_v3'

class YoutubeService
  def initialize
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.key = Settings.youtube_api.key

    # 参照先を明記
    if Rails.env.production?
      @service.request_options.header = { 'Referer' => 'https://jingji-portfolio.onrender.com' }
    else
      @service.request_options.header = { 'Referer' => 'http://localhost:3000' }
    end
  end

  # 動画情報の取得（チャンネルIDの抽出のみ）
  def get_video_info(video_id)
    Rails.cache.fetch("youtube_video_#{video_id}", expires_in: 1.day) do #　キャッシュ活用
      @service.list_videos('snippet', id: video_id,
                          fields: 'items(id,snippet(channelId))')
    end
  end

  # チャンネル情報の取得（表示に必要な最小限のデータ）
  def get_channel_info(channel_id)
    Rails.cache.fetch("youtube_channel_#{channel_id}", expires_in: 12.hours) do #　キャッシュ活用
      @service.list_channels('snippet,statistics', id: channel_id,
                            fields: 'items(id,snippet(title,thumbnails/default),statistics(subscriberCount,hiddenSubscriberCount))')
    end
  end
end
