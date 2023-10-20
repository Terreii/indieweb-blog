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

    title = Faker::Games::Zelda.game
    fill_in "Title", with: title
    fill_in "Url", with: Faker::Internet.url
    click_on "Create Entry"

    assert_text title
    click_on "Back"
  end

  test "should create bookmark with a summary" do
    login

    visit bookmarks_url
    click_on "Create new Bookmark"

    title = Faker::Games::Zelda.game
    fill_in "Title", with: title
    fill_in "Url", with: Faker::Internet.url
    fill_in_rich_text_area "Summary", with: Faker::Lorem.paragraphs

    fill_in "Create new tag", with: "games"
    click_on "Create Tag"
    assert_text "games"
    check "games"
    check tags(:bands).name

    click_on "Create Entry"

    assert_text title
    assert_link "games"
    assert_link tags(:bands).name
    click_on "Back"
  end

  test "should create bookmark with other language" do
    login

    visit bookmarks_url
    click_on "Create new Bookmark"

    title = Faker::Games::Zelda.game
    fill_in "Title", with: title
    fill_in "Url", with: Faker::Internet.url

    select "german", from: "entry_language"

    click_on "Create Entry"

    assert_text title
    click_on "Back"

    assert_equal "german", Bookmark.last.entry.language
  end

  test "should update Bookmark" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    title = @entry.title + " Hello World!"
    fill_in "Title", with: title
    fill_in "Url", with: @bookmark.url

    fill_in "Create new tag", with: "rails"
    click_on "Create Tag"
    assert_text "rails"
    check "rails"
    check tags(:programming).name

    click_on "Update Entry"

    assert_text title
    assert_link "rails"
    assert_link tags(:programming).name
    click_on "Back"
  end

  test "should update Bookmark summary" do
    login

    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark", match: :first

    fill_in "Title", with: @entry.title
    fill_in "Url", with: @bookmark.url
    summary = Faker::Lorem.paragraphs.join
    fill_in_rich_text_area "Summary", with: summary
    click_on "Update Entry"

    assert_text summary
    click_on "Back"
  end

  test "should destroy Bookmark" do
    login

    title = @bookmark.entry.title
    visit bookmark_url(@bookmark)
    click_on "Edit this bookmark"

    assert_difference ["Entry.count", "Bookmark.count"], -1 do
      page.accept_confirm do
        click_on "Destroy this bookmark", match: :first
      end
      sleep 0.1
    end

    assert_no_text title
  end
end
