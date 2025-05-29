class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    # ジャンル名にユニーク制約を追加
    add_index :tags, :name, unique: true
  end
end
