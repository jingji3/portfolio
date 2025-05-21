class Genre < ApplicationRecord
  has_many :post_to_genres, dependent: :destroy
  has_many :posts, through: :post_to_genres

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
end
