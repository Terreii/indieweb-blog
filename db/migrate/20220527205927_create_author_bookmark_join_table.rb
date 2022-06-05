class CreateAuthorBookmarkJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :authors, :bookmarks do |t|
      t.index [:author_id, :bookmark_id], unique: true
      t.index [:bookmark_id, :author_id]
    end
  end
end
