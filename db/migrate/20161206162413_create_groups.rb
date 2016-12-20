class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.string :kind
      t.string :status
      t.integer :cover_id

      t.timestamps
    end
  end
end
