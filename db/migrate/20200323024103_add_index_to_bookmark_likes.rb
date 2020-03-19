class AddIndexToBookmarkLikes < ActiveRecord::Migration[6.0]
  def change
    add_index :bookmark_likes, [:likeable_type, :likeable_id, :user_id,
      :type_action], unique: true, name: :add_unique_index
  end
end
