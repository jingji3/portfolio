class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :post_id, null: false
      t.string :comment, null: false
      t.integer :parent_id

      t.timestamps
    end

    add_index :comments, :parent_id
  end
end
