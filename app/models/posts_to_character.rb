class PostsToCharacter < ApplicationRecord
  belongs_to :post
  belongs_to :character

  validates :constellation, presence: true, inclusion: { in: 0..6 }
end
