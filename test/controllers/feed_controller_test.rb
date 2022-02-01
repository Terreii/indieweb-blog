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
end
