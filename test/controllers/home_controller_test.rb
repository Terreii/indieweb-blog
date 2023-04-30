require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should have all entry types" do
    get root_url

    post = entries(:first_post)
    bookmark = entries(:first_bookmark)

    # Check if all types are tested
    # This will fail as soon as a new type is added to Entry
    types = [bookmark, post].map do |entry|
      entry.entryable_type
    end
    assert_equal Entry.types, types, "All Entryable types should be tested"

    assert_select "##{dom_id post} h1", text: post.title
    assert_select "##{dom_id bookmark} h1", text: "Bookmarked: " + bookmark.title
  end
end
