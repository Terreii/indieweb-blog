class MoveBookmarksToEntries < ActiveRecord::Migration[7.0]
  def up
    execute %(
      INSERT INTO entries(title, published_at, entryable_type, entryable_id, created_at, updated_at)
        SELECT title, created_at, 'Bookmark', id, created_at, updated_at
        FROM bookmarks;
    )
    remove_columns :bookmarks, :title, :created_at, :updated_at

    execute %(
      INSERT INTO entries_tags(entry_id, tag_id)
      SELECT id AS entry_id, tag_id
        FROM bookmarks_tags
        INNER JOIN entries
          ON entryable_id = bookmark_id
        WHERE entryable_type = 'Bookmark';
    )
    drop_join_table :bookmarks, :tags
  end

  def down
    create_join_table :bookmarks, :tags do |t|
      t.index [:bookmark_id, :tag_id]
      t.index [:tag_id, :bookmark_id], unique: true
    end
    execute %(
      INSERT INTO bookmarks_tags(bookmark_id, tag_id)
      SELECT entryable_id AS bookmark_id, tag_id
        FROM entries_tags
        INNER JOIN entries
          ON id = entry_id
        WHERE entryable_type = 'Bookmark';
    )
    execute %(
      DELETE FROM entries_tags
        USING entries
        WHERE entries.id = entries_tags.entry_id
          AND entries.entryable_type = 'Bookmark';
    )

    change_table :bookmarks do |t|
      t.column :title, :string
      t.timestamps null: true
    end
    execute %(
      UPDATE bookmarks b
        SET title = e.title,
            created_at = e.created_at,
            updated_at = e.updated_at
        FROM entries e
        WHERE e.entryable_type = 'Bookmark' AND b.id = e.entryable_id;
    )
    Entry.where(entryable_type: "Bookmark").delete_all
    change_table :bookmarks do |t|
      t.change_null :created_at, false
      t.change_null :updated_at, false
    end
  end
end
