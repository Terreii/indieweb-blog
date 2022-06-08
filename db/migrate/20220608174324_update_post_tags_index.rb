class UpdatePostTagsIndex < ActiveRecord::Migration[7.0]
  def change
    change_table :posts_tags do |t|
      t.remove_index [:tag_id, :post_id]
      t.index [:tag_id, :post_id], unique: true
    end
  end
end
