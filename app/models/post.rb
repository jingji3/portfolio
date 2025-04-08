class Post < ApplicationRecord
  belongs_to :user
  has_many :posts_to_characters, dependent: :destroy
  has_many :characters, through: :posts_to_characters
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  def video_embed_code
    if video_url.present?
      youtube_id = extract_youtube_id(video_url)
      return "<iframe width='560' height='315' src='https://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>" if youtube_id
    end
    nil
  end

  def extract_youtube_id(url)
    regex = /(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/
    match = regex.match(url)
    match[1] if match
  end
  
  private

end
