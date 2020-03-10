class CreateBookmarkLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmark_likes do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :type_action

      t.timestamps
    end
    add_index :bookmark_likes, :user_id
    add_index :bookmark_likes, :post_id
    add_index :bookmark_likes, [:user_id, :post_id, :type_action], unique: true
  end
end
