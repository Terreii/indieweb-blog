require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in
    visit login_url

    fill_in "username", with: Rails.application.credentials.auth[:login]
    fill_in "password", with: Rails.application.credentials.auth[:password]
    fill_in "name", with: "Test"

    click_button "Login"
  end
end
