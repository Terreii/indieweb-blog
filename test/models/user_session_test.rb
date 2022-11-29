require "test_helper"

class UserSessionTest < ActiveSupport::TestCase
  setup do
    @username = Rails.application.credentials.auth[:login]
    @password = Rails.application.credentials.auth[:password]
  end

  test "should find a session" do
    user_session_id = user_sessions(:existing).id
    assert_nothing_raised { UserSession.find user_session_id }
  end

  test "should create a session with the correct credentials" do
    user_session = UserSession.authenticate @username, @password, ""
    assert_instance_of UserSession, user_session
  end

  test "should return nil if credentials are wrong" do
    user_session = UserSession.authenticate "some_username", "super_secret", ""
    assert_nil user_session
  end

  test "should save a new session" do
    name = "Firefox Developer Edition"
    user_session = UserSession.authenticate @username, @password, name

    found_session = UserSession.find(user_session.id)
    assert_equal name, found_session.name
  end

  test "should find_and_log_current session" do
    user_session_id = user_sessions(:existing).id
    user_session = UserSession.find_and_log_current user_session_id
    assert_not_nil user_session
    assert_in_delta DateTime.now.to_i, user_session.last_online.to_i, 5
  end

  test "should update session" do
    user_session = user_sessions(:existing)
    name = Faker::Kpop.iii_groups
    user_session.update(name: name)
    assert_equal name, user_session.reload.name
  end

  test "should destroy a session" do
    user_session = user_sessions(:existing)
    user_session.destroy
    assert_raise(ActiveRecord::RecordNotFound) { UserSession.find(user_session.id) }
  end
end
