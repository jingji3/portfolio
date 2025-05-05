class Team < ApplicationRecord
  has_many :team_to_characters, dependent: :destroy
  has_many :characters, through: :team_to_characters
  has_many :team_ratings, dependent: :destroy
  has_many :users, through: :team_ratings

  # チームの平均評価を算出する
  def average_rating
    team_ratings.average(:rating).to_f.round(1)
  end

  # 評価数を算出
  def ratings_count
    team_ratings.count
  end

  # キャラクターIDの配列からチームを
  def self.find_by_character_ids(character_ids) # selfでクラスメソッドから呼び出せるようにして
    sorted_ids = character_ids.sort

    joins(:team_to_characters)
      .where(team_to_characters: { character_id: sorted_ids }) # キャラIDはソートして取得
      .group('teams.id')
      .having('COUNT(DISTINCT team_to_characters.character_id) = ?', sorted_ids.size) # 4体のキャラが選択された時という条件を作る
      .first # 見つけた時点で終了
  end

  # チームに4対のキャラがいるか確認するバリデーション
  def has_four_characters?
    characters.count == 4
  end
end
