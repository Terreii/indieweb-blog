# == Schema Information
#
# Table name: user_sessions
#
#  id          :bigint           not null, primary key
#  last_online :datetime         not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class UserSession < ApplicationRecord
  # Stores an active session, so that it can be deleted.
  def self.authenticate(username, password, name)
    return unless Rails.application.credentials.auth[:login] == username
    return unless Rails.application.credentials.auth[:password] == password

    user_session = UserSession.new name: name, last_online: DateTime.now
    return user_session if user_session.save
  end

  def self.find_and_log_current(session_id)
    user_session = find_by(id: session_id)
    return if user_session.nil?
    user_session.update last_online: DateTime.now
    user_session
  end

  after_create_commit { broadcast_prepend_later_to("user_sessions", target: "session_list") }
  after_update_commit {
    # Return if only last_online did change (count == 2 because updated_at will always be updated, too.
    # This fixes a race condition when updating the current session. A replace would be send,
    # because of updating last_online.
    unless previous_changes.count == 2 && last_online_previously_changed?
      broadcast_replace_later_to("user_sessions")
    end
  }
  after_destroy_commit { broadcast_remove_to("user_sessions") }
end
