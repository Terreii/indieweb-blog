class ChangeTagsNameIndexToUnique < ActiveRecord::Migration[6.1]
  def change
    remove_index :tags, :name
    add_index :tags, :name, unique: true
  end
end
