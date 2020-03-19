class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :post_id
      t.integer :type_notif
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :notifications, [:sender_id, :receiver_id]
  end
end
