class CreateTeamToCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :team_to_characters do |t|
      t.references :team, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps

      t.index %i[team_id character_id], unique: true
    end
  end
end
