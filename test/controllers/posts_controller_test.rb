require "test_helper"
require "webmock/minitest"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @post = posts(:first_post)
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
      post posts_url, params: {
        post: {
          published_at: @post.published_at,
          title: Faker::Games::DnD.alignment
        }
      }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should create post with new tags" do
    login
    assert_difference ['Post.count', 'Tag.count'] do
      post posts_url, params: {
        post: {
          published_at: @post.published_at,
          title: Faker::Games::DnD.alignment
        },
        new_tags: 'moar'
      }
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

  test "should enqueue a WebMention Job for every uri in the body" do
    source = post_url(posts(:draft_post))
    target = "http://tester.io/article/1"
    login

    assert_enqueued_with job: WebmentionJob, args: [{ source:, target: }] do
      post = post_params_with_links
      post[:published_at] = Time.now
      patch source, params: { post: }
    end
  end

  test "should not queue a WebMention Job if post is not published" do
    source = post_url(posts(:draft_post))
    login

    assert_no_enqueued_jobs only: WebmentionJob do
      patch source, params: { post: post_params_with_links }
    end
  end

  test "should enqueue a WebMention Job for every uri in a new post body" do
    source = post_url(posts(:draft_post))
    target = "http://tester.io/article/1"
    login

    assert_enqueued_with job: WebmentionJob do
      post = post_params_with_links
      post[:published_at] = Time.now
      post posts_url, params: {
        post:
      }
    end
  end

  test "should not queue a WebMention Job if new post is not published" do
    login

    assert_no_enqueued_jobs only: WebmentionJob do
      post posts_url, params: { post: post_params_with_links }
    end
  end

  test "should not queue a Webmention Job for links to own domain" do
    login
    link = post_url(posts(:draft_post))

    assert_no_enqueued_jobs only: WebmentionJob do
      post posts_url, params: {
        post: {
          title: Faker::Games::DnD.alignment,
          published_at: Time.now,
          body: "<p>Test<a href=\"#{link}\">their post</a></p>"
        }
      }
    end
  end

  test "should not queue a Webmention Job for not saved posts" do
    login

    assert_no_enqueued_jobs only: WebmentionJob do
      post posts_url, params: { post: post_params_with_links }
    end
  end

  def post_params_with_links
    {
      title: Faker::Games::DnD.alignment,
      body: <<~HTML
        <p>
          Test
          <a href="http://tester.io/article/1">their post</a>
        </p>
      HTML
    }
  end
end
