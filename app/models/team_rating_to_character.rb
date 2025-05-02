class TeamRatingToCharacter < ApplicationRecord
  berongs_to :team_rating
  belongs_to :character

  # team_rating_idに対してユニークになるように設定
  validates :character_id, uniquencess: { scope: :team_rating_id }
end
