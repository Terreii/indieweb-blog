require "application_system_test_case"

class BookmarksTest < ApplicationSystemTestCase
  setup do
    @bookmark = bookmarks(:first_bookmark)
    @entry = @bookmark.entry
  end

  test "visiting the index" do
    visit bookmarks_url
    assert_selector "h1", text: "Bookmarks"
    assert_css ".h-feed .h-entry", count: 2
  end

  test "should create bookmark" do
    login

    visit bookmarks_url
    click_on "Create new Bookmark"

    fill_in "Title", with: Faker::Games::Zelda.game
    fill_in "Url", with: Faker::Internet.url
    click_on "Create Bookmark"

    assert_text "Bookmark was successfully created"
    click_on "Back"
  end

  test "should create bookmark with a summary" do
    login

    visit bookmarks_url
    click_on "Create new Bookmark"

    fill_in "Title", with: Faker::Games::Zelda.game
    fill_in "Url", with: Faker::Internet.url
    fill_in_rich_text_area "Summary", with: Faker::Lorem.paragraphs

    fill_in "Create new tag", with: "games"
    click_on "Create Tag"
    assert_text "games"
    check "games"
    check tags(:bands).name

    click_on "Create Bookmark"

    assert_text "Bookmark was successfully created"
    assert_link "games"
    assert_link tags(:bands).name
    click_on "Back"
  end

  test "should update Bookmark" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    fill_in "Title", with: @entry.title
    fill_in "Url", with: @bookmark.url

    fill_in "Create new tag", with: "rails"
    click_on "Create Tag"
    assert_text "rails"
    check "rails"
    check tags(:programming).name

    click_on "Update Bookmark"

    assert_text "Bookmark was successfully updated"
    assert_link "rails"
    assert_link tags(:programming).name
    click_on "Back"
  end

  test "should update Bookmark a summary" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    fill_in "Title", with: @entry.title
    fill_in "Url", with: @bookmark.url
    fill_in_rich_text_area "Summary", with: Faker::Lorem.paragraphs
    click_on "Update Bookmark"

    assert_text "Bookmark was successfully updated"
    click_on "Back"
  end

  test "should destroy Bookmark" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark"
    click_on "Destroy this bookmark", match: :first

    assert_text "Bookmark was successfully destroyed"
  end
end
