class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :parent_id
      t.belongs_to :post, nul: false, foreign_key: true
      t.belongs_to :user, nul:false, foreign_key: true
      t.timestamps
    end

    add_index :comments, :parent_id
  end
end
