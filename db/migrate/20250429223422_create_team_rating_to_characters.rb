class CreateTeamRatingToCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :team_rating_to_characters do |t|
      t.references :team_rating, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end

    # 同じteam_rating内に同じキャラクターが重複登録されてしまうことを避けるためのindex name:は保守用の名前
    add_index :team_rating_to_characters, [:team_rating_id, :character_id], unique: true, name: 'index_team_rating_characters_on_team_rating_id_and_character_id'
  end
end
