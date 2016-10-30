class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :password_digest
      t.date :birthday
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
