class Post < ApplicationRecord
  belongs_to :user
  has_many :posts_to_characters, dependent: :destroy
  has_many :characters, through: :posts_to_characters
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_to_genres, dependent: :destroy
  has_many :genres, through: :post_to_genres

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :video_url, presence: true, length: { maximum: 255 }
  validates :youtube_start_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # いいね用メソッド
  def liked_by?(user)
    return false if user.nil?
    likes.exists?(user_id: user.id)
  end

  # お気に入り用メソッド
  def favorite_by?(user)
    return false if user.nil?
    favorites.exists?(user_id: user.id)
  end

  # 秒数を分：秒に変換するメソッド
  def formatted_start_time
    return nil if youtube_start_time.present?

    minutes = youtube_start_time / 60
    seconds = youtube_start_time % 60
    format("%d:%02d", minutes, seconds)
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["characters", "posts_to_characters"]
  end

  scope :with_any_characters, ->(character_ids) {
    character_ids = Array(character_ids).compact.reject(&:blank?)
    return all if character_ids.empty?

    joins(:posts_to_characters)
      .where(posts_to_characters: { character_id: character_ids })
      .distinct
  }

end
