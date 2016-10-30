class AddStatusToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :status, :string
  end
end
