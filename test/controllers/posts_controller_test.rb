require "test_helper"
require "webmock/minitest"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @post = posts(:first_post)
    @entry = @post.entry
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
          published: "1",
          title: Faker::Games::DnD.alignment,
          summary: Faker::Lorem.paragraph,
          body: "<p>#{Faker::Lorem.paragraphs.join "</p><p>"}</p>"
        }
      }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should create post with thumbnail" do
    login
    assert_difference('Post.count') do
      post posts_url, params: {
        post: {
          published: "1",
          title: Faker::Games::DnD.alignment,
          thumbnail: fixture_file_upload("sample.jpg", "image/jpeg", :binary),
          body: "<div>#{Faker::Lorem.paragraph}"
        }
      }
    end

    assert_redirected_to post_url(Post.last)
    assert Post.last.thumbnail.present?
  end

  test "should require a session to create a post" do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { published: "1", title: @post.title } }
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
    patch post_url(@post), params: { post: { published: "1", title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should require a session to update a post" do
    patch post_url(@post), params: { post: { published: "1", title: @post.title } }
    assert_redirected_to login_path
  end

  test "should destroy post" do
    login
    assert_difference ['Entry.count', 'Post.count'], -1  do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "should require a session to destroy post" do
    assert_no_difference ['Entry.count', 'Post.count'] do
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
      post[:published] = "1"
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
      post[:published] = "1"
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
          published: "1",
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

  test "should only enqueue one Webmention Job for a domain" do
    login

    assert_enqueued_jobs 1, only: WebmentionJob do
      post posts_url, params: {
        post: {
          title: Faker::Games::DnD.alignment,
          published: "1",
          body: <<~HTML
            <p>
              Test
              <a href="http://tester.io/article/1">their post</a>
              and
              <a href="http://tester.io/article/1">their post again</a>
            </p>
          HTML
        }
      }
    end
  end

  test "should enqueue a Webmention Job for removed links" do
    login

    assert_enqueued_jobs 1, only: WebmentionJob do
      blog_post = posts(:post_with_links)
      patch post_url(blog_post), params: {
        post: {
          body: <<~HTML
            <p>This was a post</p>
          HTML
        }
      }
    end
  end

  def post_params_with_links
    {
      title: Faker::Games::DnD.alignment,
      published: "0",
      summary: Faker::Lorem.paragraph,
      body: <<~HTML
        <p>
          Test
          <a href="http://tester.io/article/1">their post</a>
        </p>
      HTML
    }
  end
end
