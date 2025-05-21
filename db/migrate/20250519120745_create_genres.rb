class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end

    # ジャンル名にユニーク制約を追加
    add_index :genres, :name, unique: true
  end
end
