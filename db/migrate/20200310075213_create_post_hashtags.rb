class CreatePostHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :post_hashtags do |t|
      t.belongs_to :post, nul: false, foreign_key: true
      t.belongs_to :hashtag, nul:false, foreign_key: true
      t.timestamps
    end
  end
end
