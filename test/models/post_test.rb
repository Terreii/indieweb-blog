require 'faker'
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should create post" do
    post = Post.new

    post.title = Faker::Games::DnD.alignment
    post.body = "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"

    assert post.save
  end

  test "should find post" do
    post_id = posts(:first_post).id
    assert_nothing_raised { Post.find post_id }
  end

  test "should find all published posts" do
    posts = Post.published
    post_id = posts(:first_post).id
    assert_equal 3, posts.count
    assert_equal post_id, posts.last.id
  end

  test "should find all draft posts" do
    posts = Post.draft
    post_id = posts(:draft_post).id
    assert_equal 1, posts.count
    assert_equal post_id, posts.first.id
  end

  test "should update post" do
    post = posts(:first_post)
    title = Faker::Kpop.boy_bands
    post.update(title: title)
    assert_equal title, post.reload.title
  end

  test "should use the current time when published? is set to true" do
    post = posts(:draft_post)
    post.update published: true
    assert post.published?
    assert_not_nil post.published_at
  end

  test "should destroy post" do
    post = posts(:first_post)
    post.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Post.find(post.id) }
  end

  test "should not create a post without title" do
    post = Post.new
    assert_not post.save

    assert_not_empty post.errors[:title]
    assert_equal ["can't be blank"], post.errors[:title]
  end

  test "should not create a post with a not unique slug" do
    post = Post.new title: posts(:first_post).title, slug: posts(:first_post).slug, body: ""
    assert_raise(ActiveRecord::RecordNotUnique) { post.save }
  end

  test "should validate a posts slug" do
    post = Post.new({
      title: Faker::Games::DnD.alignment,
      slug: "some!_not allowed",
      body: "<p>Test</p>"
    })
    assert_not post.save

    assert_not_empty post.errors[:slug]
    assert_equal ["is invalid"], post.errors[:slug]
  end
end
