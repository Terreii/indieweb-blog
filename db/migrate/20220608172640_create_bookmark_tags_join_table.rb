class CreateBookmarkTagsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :bookmarks, :tags do |t|
      t.index [:bookmark_id, :tag_id]
      t.index [:tag_id, :bookmark_id], unique: true
    end
  end
end
