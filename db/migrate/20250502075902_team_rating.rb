class TeamRating < ActiveRecord::Migration[7.1]
  def change
    create_table :team_ratings do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :body
      t.decimal :rating, precision: 3, scale: 1, null: false # 3桁かつ小数点は1位までとする

      t.timestamps

      t.index %i[team_id user_id], unique: true # 同じユーザーが同じチームに複数の評価できないように制限
    end
  end
end
