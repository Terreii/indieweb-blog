require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    login
    get new_post_url
    assert_response :success
  end

  test "should require a session to get new" do
    get new_post_url
    assert_redirected_to login_path
  end

  test "should create post" do
    login
    assert_difference('Post.count') do
      post posts_url, params: { post: { published_at: @post.published_at, title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should require a session to create a post" do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { published_at: @post.published_at, title: @post.title } }
    end

    assert_redirected_to login_path
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    login
    get edit_post_url(@post)
    assert_response :success
  end

  test "should require a session to edit a post" do
    get edit_post_url(@post)
    assert_redirected_to login_path
  end

  test "should update post" do
    login
    patch post_url(@post), params: { post: { published_at: @post.published_at, title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should require a session to update a post" do
    patch post_url(@post), params: { post: { published_at: @post.published_at, title: @post.title } }
    assert_redirected_to login_path
  end

  test "should destroy post" do
    login
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "should require a session to destroy post" do
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end

    assert_redirected_to login_path
  end
end
