require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bookmark = bookmarks(:one)
  end

  test "should get index" do
    get bookmarks_url
    assert_response :success
  end

  test "should get new" do
    login
    get new_bookmark_url
    assert_response :success
  end

  test "new should require a session" do
    get new_bookmark_url
    assert_redirected_to login_path
  end

  test "should create bookmark" do
    login

    assert_difference("Bookmark.count") do
      post bookmarks_url, params: {
        bookmark: {
          title: Faker::Games::Zelda.game,
          url: Faker::Internet.url
        }
      }
    end

    assert_redirected_to bookmark_url(Bookmark.first)
  end

  test "create should require a session" do
    assert_no_difference("Bookmark.count") do
      post bookmarks_url, params: {
        bookmark: {
          title: Faker::Games::Zelda.game,
          url: Faker::Internet.url
        }
      }
    end

    assert_redirected_to login_path
  end

  test "should show bookmark" do
    get bookmark_url(@bookmark)
    assert_response :success
  end

  test "should get edit" do
    login
    get edit_bookmark_url(@bookmark)
    assert_response :success
  end

  test "edit should require a session" do
    get edit_bookmark_url(@bookmark)
    assert_redirected_to login_path
  end

  test "should update bookmark" do
    login
    patch bookmark_url(@bookmark), params: { bookmark: { title: @bookmark.title, url: @bookmark.url } }
    assert_redirected_to bookmark_url(@bookmark)
  end

  test "update should require a session" do
    patch bookmark_url(@bookmark), params: { bookmark: { title: @bookmark.title, url: @bookmark.url } }
    assert_redirected_to login_path
  end

  test "should destroy bookmark" do
    login
    assert_difference("Bookmark.count", -1) do
      delete bookmark_url(@bookmark)
    end

    assert_redirected_to bookmarks_url
  end

  test "destroy should require a session" do
    assert_no_difference("Bookmark.count") do
      delete bookmark_url(@bookmark)
    end

    assert_redirected_to login_path
  end
end
