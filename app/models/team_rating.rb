class TeamRating < ApplicationRecord
  belongs_to :user
  has_many :team_rating_to_characters, dependent: :destroy
  has_many :characters, through: :team_rating_to_characters

  # 評価は1.0~5.0にする
  validates :rating, presence: true,
                     numericality: {
                       greater_than_or_equal_to: 1.0,
                       less_than_or_equal_to: 5.0
                     }

  # 4体キャラクターセットに対して行うためのバリデーション
  validate :has_four_characters, on: :create

  # チームの平均評価取得メソッド
  def self.avaratge_rating_for_characters(character_ids)
    joins(:team_rating_to_characters)
      .where(team_rating_to_characters: { character_id: character_ids })
      .group('team_rating.id')
      .having('COUNT(team_rating_to_characters.character_id) = ?', character_ids.size)
      .average(:rating)
      .to_f
      .round(1)
  end

  private

  def has_four_characters
    return unless team_rating_to_characters.size != 4

    errors.add(:base, 'キャラクター4体を選択してください')
  end
end
