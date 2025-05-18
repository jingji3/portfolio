module YoutubeHelper
  def extract_youtube_id(url)
    return nil unless url.present?
    regex = /(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/ # YouTubeのURLから動画IDを抽出する正規表現
    match = regex.match(url) # URLが正規表現にマッチするか確認
    match[1] if match # 抽出した動画IDを返す match[0]がURLそのもので、match[1]が動画ID
  end
end
