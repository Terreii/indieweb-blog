class MovePostToEnties < ActiveRecord::Migration[7.0]
  def up
    execute %(
      INSERT INTO entries(title, published_at, entryable_type, entryable_id, created_at, updated_at)
      SELECT title, published_at, 'Post', id, created_at, updated_at
      FROM posts;
    )
    remove_columns :posts, :title, :published_at, :created_at, :updated_at
  end

  def down
    change_table :posts do |t|
      t.column :title, :string
      t.column :published_at, :datetime
      t.timestamps null: true
    end
    execute %(
      UPDATE posts p
      SET title = e.title,
          published_at = e.published_at,
          created_at = e.created_at,
          updated_at = e.updated_at
      FROM entries e
      WHERE e.entryable_type = 'Post' AND p.id = e.entryable_id;
    )
    Entry.where(entryable_type: "Post").delete_all
    change_table :posts do |t|
      t.change_null :created_at, false
      t.change_null :updated_at, false

      t.index :published_at
    end
  end
end
