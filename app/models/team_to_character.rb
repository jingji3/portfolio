class TeamToCharacter < ApplicationRecord
  belongs_to :team
  belongs_to :character

  # teamに対してキャラクターは1体のみのバリデーション
  validates :character_id, uniqueness: { scope: :team_id }
end
