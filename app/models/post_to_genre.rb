class PostToGenre < ApplicationRecord
  belongs_to :post
  belongs_to :genre

  validates :genre_id, uniqueness: { scope: :post_id }
end
