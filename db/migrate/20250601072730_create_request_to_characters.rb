class CreateRequestToCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :request_to_characters do |t|
      t.references :request, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
    # 同じRequestに同じCharacterが複数回登録されることを防ぐ
    add_index :request_to_characters, [ :request_id, :character_id ], unique: true
  end
end
