require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tags_url
    assert_response :success
  end

  test "should get show" do
    get tags_url(:bands)
    assert_response :success
  end
end
