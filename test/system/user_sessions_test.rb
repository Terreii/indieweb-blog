require "application_system_test_case"

class UserSessionsTest < ApplicationSystemTestCase
  include ActionView::Helpers::DateHelper

  setup do
    @user_session = user_sessions(:existing)
  end

  test "visiting the index" do
    login

    visit user_sessions_url
    assert_selector "h1", text: "Active Sessions"
    # List active sessions
    assert_selector "td", text: "Current" # Current Session
    other_session = time_ago_in_words user_sessions(:existing).last_online
    assert_selector "td > time", text: other_session
  end

  test "creating a User session" do
    visit login_url

    fill_in "username", with: Rails.application.credentials.auth[:login]
    fill_in "password", with: Rails.application.credentials.auth[:password]
    fill_in "name", with: "Test"

    click_button "Login"

    assert_text "Logged in successfully"
    click_on "Christophers thoughts"
  end

  test "updating a User session" do
    login

    visit user_sessions_url
    click_on "Edit", match: :first

    fill_in "Name", with: @user_session.name
    click_on "Update User session"

    assert_text "User session was successfully updated"
    click_on "Back"
  end

  test "destroying a User session" do
    login

    visit user_sessions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "You successfully logged out"
  end

  test "logout" do
    login

    click_on "Logout"

    assert_text "You successfully logged out"
  end
end
