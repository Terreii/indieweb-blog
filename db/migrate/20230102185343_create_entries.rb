class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.string :title
      t.datetime :published_at
      t.references :entryable, polymorphic: true, null: false

      t.timestamps
    end
    add_index :entries, :published_at
  end
end
