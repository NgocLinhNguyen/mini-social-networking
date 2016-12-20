class AddColumnToUserGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :user_groups, :status, :string
  end
end
