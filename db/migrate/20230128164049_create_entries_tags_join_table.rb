class CreateEntriesTagsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :entries, :tags do |t|
      t.index [:entry_id, :tag_id], unique: true
      t.index [:tag_id, :entry_id]
    end
  end
end
