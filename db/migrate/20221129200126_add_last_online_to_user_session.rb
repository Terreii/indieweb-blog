class AddLastOnlineToUserSession < ActiveRecord::Migration[7.0]
  def change
    add_column :user_sessions, :last_online, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
