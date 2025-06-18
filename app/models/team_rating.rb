class TeamRating < ApplicationRecord
  belongs_to :team
  belongs_to :user

  # 評価は1.0~5.0にする
  validates :rating, presence: true,
                     numericality: {
                       greater_than_or_equal_to: 1.0,
                       less_than_or_equal_to: 5.0,
                       step: 0.5
                     }
  # すでに評価済みの編成の場合エラーを表示
  validates :user_id, uniqueness: { scope: :team_id }
end
