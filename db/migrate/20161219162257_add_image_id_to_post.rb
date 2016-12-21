class AddImageIdToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :image_id, :integer
  end
end
