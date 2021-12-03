class UserSession < ApplicationRecord
  # Stores an active session, so that it can be deleted.
  def self.authenticate(username, password, name)
    return unless Rails.application.credentials.auth[:login] == username
    return unless Rails.application.credentials.auth[:password] == password

    user_session = UserSession.new name: name
    return user_session if user_session.save
  end
end
