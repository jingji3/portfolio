class CreatePostToTags < ActiveRecord::Migration[7.1]
  def change
    create_table :post_to_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    # 同じ投稿に対して同じジャンルが複数回関連付けられないようにするためのユニーク制約を追加
    add_index :post_to_tags, [:post_id, :tag_id], unique: true
  end
end
