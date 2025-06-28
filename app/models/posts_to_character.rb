class PostsToCharacter < ApplicationRecord
  belongs_to :post
  belongs_to :character

  validates :constellation, presence: true, inclusion: { in: 0..6 }

  private

  def self.ransackable_attributes(auth_object = nil)
    [ "character_id", "post_id", "constellation" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
