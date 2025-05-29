class Tag < ApplicationRecord
  has_many :post_to_tags, dependent: :destroy
  has_many :posts, through: :post_to_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
