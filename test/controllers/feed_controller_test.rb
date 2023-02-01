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
    assert_match "<updated>#{post.updated_at.strftime "%FT%TZ"}</updated>", @response.body
  end

  test "should include bookmarks" do
    get feed_url(format: :atom)

    bookmark = bookmarks(:one)
    assert_match "<title>#{bookmark.title}</title>", @response.body
    assert_match bookmark_url(bookmark), @response.body
  end
end
