require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    assert_selector "h1", text: "Hi, I'm Christopher Astfalk!"
    assert_selector "h2", text: "📨 Latest"
    assert_selector "h1", text: posts(:first_post).title
    assert_selector "p", text: "Bookmarked: #{bookmarks(:one).title}"
  end
end
