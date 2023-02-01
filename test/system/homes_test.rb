require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    assert_selector "h1", text: "Hi, I'm Christopher Astfalk!"
    assert_selector "h2", text: "📨 Latest"
    assert_selector "h1", text: entries(:first_post).title
    assert_selector "p", text: "Bookmarked: #{bookmarks(:one).title}"
    assert_css ".h-feed .h-entry", count: 5
  end

  test "should render all accounts" do
    visit root_url

    Rails.configuration.x.accounts.each_value do |account|
      assert_selector "a[rel=me]", text: account[:user]
    end
  end
end
