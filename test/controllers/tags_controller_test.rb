require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  def save_name
    name = ""
    while name.length < 2
      name = Faker::Lorem.word.downcase
    end
    name
  end

  test "should get index" do
    get tags_url
    assert_response :success
  end

  test "should get show" do
    get tags_url(:bands)
    assert_response :success
  end

  test "should create a new tag" do
    login
    name = save_name

    assert_difference('Tag.count') do
      post tags_url, params: { name: }
    end

    assert_redirected_to tag_url(Tag.find_by(name:))
  end

  test "create should reuse a existing tag" do
    login

    assert_no_difference("Tag.count") do
      post tags_url, params: {
        name: tags(:bands).name
      }
    end

    assert_redirected_to tag_url(:bands)
  end

  test "create should require a session" do
    name = save_name
    assert_no_difference('Post.count') do
      post posts_url, params: { name: }
    end

    assert_redirected_to login_path
  end
end
