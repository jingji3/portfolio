class CreatePostsToCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :posts_to_characters do |t|
      t.references :post, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.integer :constellation, default: 0

      t.timestamps
    end
  end
end
