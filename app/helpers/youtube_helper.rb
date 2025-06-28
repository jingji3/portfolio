module YoutubeHelper
  # YouTubeの動画IDを抽出するメソッド
  def extract_youtube_id(url)
    return nil unless url.present?
    regex = /(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/ # YouTubeのURLから動画IDを抽出する正規表現
    match = regex.match(url) # URLが正規表現にマッチするか確認
    match[1] if match # 抽出した動画IDを返す match[0]がURLそのもので、match[1]が動画ID
  end

    # YouTubeの埋め込みURLを生成（再生時間指定付き）
    def youtube_embed_url_with_time(url, start_time = nil)
      video_id = extract_youtube_id(url)
      return nil unless video_id

      embed_url = "https://www.youtube.com/embed/#{video_id}"
      embed_url += "?start=#{start_time}" if start_time.present?
      embed_url
    end

    # 秒数を「時:分:秒」形式に変換
    def format_time(seconds)
      return nil unless seconds.present?

      hours = seconds / 3600
      minutes = (seconds % 3600) / 60
      secs = seconds % 60

      if hours > 0
        format("%d:%02d:%02d", hours, minutes, secs)
      else
        format("%d:%02d", minutes, secs)
      end
    end
end
