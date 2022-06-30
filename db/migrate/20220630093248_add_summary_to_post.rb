class AddSummaryToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :summary, :text, null: false, default: ""
  end
end
