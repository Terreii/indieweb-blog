class UserSession < ApplicationRecord
  # Stores an active session, so that it can be deleted.
  def self.authenticate(username, password, name)
    return unless Rails.application.credentials.auth[:login] == username
    return unless Rails.application.credentials.auth[:password] == password

    user_session = UserSession.new name: name
    return user_session if user_session.save
  end

  def self.find_and_log_current(session_id)
    user_session = find_by(id: session_id)
    return if user_session.nil?
    user_session.update last_online: DateTime.now
    user_session
  end
end
