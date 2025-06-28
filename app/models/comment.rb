class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 65_535 }

  def edited?
    created_at != updated_at
  end

  def liked_by?(user)
    return false if user.nil?

    comment_likes.exists?(user_id: user.id)
  end
end
