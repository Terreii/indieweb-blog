require 'faker'
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should create post" do
    post = Entry.build_with_post(
      title: Faker::Games::DnD.alignment,
      entryable_attributes: {
        body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
      }
    )

    assert post.save
  end

  test "should find post" do
    post_id = posts(:first_post).id
    assert_nothing_raised { Post.find post_id }
  end

  test "should find all published posts" do
    posts = Entry.published.posts
    post_id = posts(:first_post).id
    assert_equal 3, posts.count
    assert_equal post_id, posts.last.id
  end

  test "should find all draft posts" do
    posts = Entry.draft.posts
    post_id = posts(:draft_post).id
    assert_equal 1, posts.count
    assert_equal post_id, posts.first.id
  end

  test "should update post" do
    post = posts(:draft_post)
    summary = Faker::Lorem.paragraph
    post.update(summary:)
    assert_equal summary, post.reload.summary
  end

  test "should destroy post" do
    post = entries(:first_post)
    post.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Entry.find(post.id) }
  end

  test "should not create a post with a not unique slug" do
    assert_raise(ActiveRecord::RecordNotUnique) {
      entry = Entry.build_with_post(
        title: entries(:first_post).title,
        entryable_attributes: {
          slug: posts(:first_post).slug,
          body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
        }
      )
      entry.save
    }
  end

  test "should validate a posts slug" do
    post = Post.new({
      slug: "some!_not allowed",
      body: "<p>Test</p>"
    })
    assert_not post.save

    assert_not_empty post.errors[:slug]
    assert_equal ["is invalid"], post.errors[:slug]
  end
end
