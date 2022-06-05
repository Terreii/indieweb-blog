require "application_system_test_case"

class BookmarksTest < ApplicationSystemTestCase
  setup do
    @bookmark = bookmarks(:one)
  end

  test "visiting the index" do
    visit bookmarks_url
    assert_selector "h1", text: "Bookmarks"
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
    click_on "Create Bookmark"

    assert_text "Bookmark was successfully created"
    click_on "Back"
  end

  test "should update Bookmark" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    fill_in "Title", with: @bookmark.title
    fill_in "Url", with: @bookmark.url
    click_on "Update Bookmark"

    assert_text "Bookmark was successfully updated"
    click_on "Back"
  end

  test "should update Bookmark a summary" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    fill_in "Title", with: @bookmark.title
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
