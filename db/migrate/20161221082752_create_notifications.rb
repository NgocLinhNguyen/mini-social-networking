class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.integer :post_id
      t.integer :group_id
      t.integer :sender_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
