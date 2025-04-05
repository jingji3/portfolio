class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :name_kana, null: false
      t.string :name_eng, null: false
      t.integer :element, null: false
      t.integer :star, null: false
      t.string :version
      t.integer :version_half
      t.string :character_img

      t.timestamps
    end
  end
end
