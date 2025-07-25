class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :body, null: false
      t.string :video_url

      t.timestamps
    end

    add_index :posts, :title
  end
end
