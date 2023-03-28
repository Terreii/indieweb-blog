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
    assert_selector "span", text: "Current" # Current Session
    other_session = time_ago_in_words user_sessions(:existing).last_online
    assert_selector "time", text: other_session
  end

  test "creating a User session" do
    visit login_url

    fill_in "username", with: Rails.application.credentials.auth[:login]
    fill_in "password", with: Rails.application.credentials.auth[:plain_password_for_tests]
    fill_in "name", with: "Test"

    click_button "Login"

    assert_text "Logged in successfully"
    click_on "Christophers thoughts"
  end

  test "updating a User session" do
    login

    visit user_sessions_url
    click_on "Edit", match: :first

    name = Faker::Games::Zelda.character
    fill_in "Name", with: name
    click_on "Update User session"

    assert_selector "h2", text: name
  end

  test "destroying a User session" do
    login
    visit user_sessions_url

    assert_difference 'UserSession.count', -1 do
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      click_on "Christophers thoughts"
    end
  end

  test "logout" do
    login

    assert_difference 'UserSession.count', -1 do
      click_on "Logout"

      assert_text "You successfully logged out"
    end
  end
end
