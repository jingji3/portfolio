class Post < ApplicationRecord
  belongs_to :user
  has_many :posts_to_characters, dependent: :destroy
  has_many :characters, through: :posts_to_characters
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :video_url, presence: true, length: { maximum: 255 }

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
