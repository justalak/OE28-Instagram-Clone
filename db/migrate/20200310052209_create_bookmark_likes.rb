class CreateBookmarkLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmark_likes do |t|
      t.integer :user_id
      t.integer :type_action
      t.references :likeable, polymorphic: true

      t.timestamps
    end
    add_index :bookmark_likes, :user_id
  end
end
