class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
