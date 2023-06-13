require "test_helper"

class FeedControllerTest < ActionDispatch::IntegrationTest
  test "should get index with atom format" do
    get feed_url(format: :atom)
    assert_response :success
  end

  test "should redirect index without format" do
    get feed_url
    assert_redirected_to feed_url(format: :atom)
  end

  test "should redirect on xml format" do
    get feed_url(format: :xml)
    assert_redirected_to feed_url(format: :atom)
  end

  test "should have the latest updated_at as updated" do
    get feed_url(format: :atom)

    post = entries(:first_post)
    assert_select "updated", post.updated_at.strftime("%FT%TZ")
  end

  test "should include bookmarks" do
    get feed_url(format: :atom)

    bookmark = bookmarks(:first_bookmark)
    assert_select "title", bookmark.entry.title
    assert_select "link[href=\"#{bookmark_url(bookmark)}\"]"
    assert_select "source > link[href=\"#{bookmark.url}\"]", nil, "should link to source"
  end
end
