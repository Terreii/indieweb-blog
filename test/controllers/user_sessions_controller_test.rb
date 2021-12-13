require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login
    get user_sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_session_url
    assert_response :success
  end

  test "should get login" do
    get login_url
    assert_response :success
  end

  test "should create user_session" do
    assert_difference('UserSession.count') do
      username = Rails.application.credentials.auth[:login]
      password = Rails.application.credentials.auth[:password]
      post user_sessions_url(username: username, password: password, name: 'Test Session')
    end

    assert_redirected_to root_path
  end

  test "should show user_session" do
    login
    user_session = UserSession.last
    get user_session_url(user_session)
    assert_response :success
  end

  test "should get edit" do
    login
    user_session = UserSession.last
    get edit_user_session_url(user_session)
    assert_response :success
  end

  test "should update user_session" do
    login
    user_session = UserSession.last
    patch user_session_url(user_session), params: { user_session: { name: "Other" } }
    assert_redirected_to user_session_url(user_session)
  end

  test "should destroy user_session" do
    login
    user_session = UserSession.last
    assert_difference('UserSession.count', -1) do
      delete user_session_url(user_session)
    end

    assert_redirected_to root_path
  end
end
