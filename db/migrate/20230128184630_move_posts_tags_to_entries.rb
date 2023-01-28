class MovePostsTagsToEntries < ActiveRecord::Migration[7.0]
  def up
    execute %(
      INSERT INTO entries_tags(entry_id, tag_id)
      SELECT id AS entry_id, tag_id
        FROM posts_tags
        INNER JOIN entries
          ON entryable_id = post_id
        WHERE entryable_type = 'Post';
    )
    drop_join_table :posts, :tags
  end

  def down
    create_join_table :posts, :tags do |t|
      t.index [:post_id, :tag_id]
      t.index [:tag_id, :post_id], unique: true
    end
    execute %(
      INSERT INTO posts_tags(post_id, tag_id)
      SELECT entryable_id AS post_id, tag_id
        FROM entries_tags
        INNER JOIN entries
          ON id = entry_id
        WHERE entryable_type = 'Post';
    )
    execute %(
      DELETE FROM entries_tags
        USING entries
        WHERE entries.id = entries_tags.entry_id
          AND entries.entryable_type = 'Post';
    )
  end
end
