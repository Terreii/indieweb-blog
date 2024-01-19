# == Schema Information
#
# Table name: posts
#
#  id      :bigint           not null, primary key
#  slug    :string
#  summary :text             default(""), not null
#
# Indexes
#
#  index_posts_on_slug  (slug) UNIQUE
#
require 'faker'
require "test_helper"

class PostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should create post" do
    post = Entry.new(
      title: Faker::Games::DnD.alignment,
      entryable: Post.new(
        summary: Faker::Lorem.paragraph,
        body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
      )
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
    assert_equal post_id, posts.last.entryable_id
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
      entry = Entry.new(
        title: entries(:first_post).title,
        entryable_type: Post.name,
        entryable_attributes: {
          slug: posts(:first_post).slug,
          summary: Faker::Lorem.paragraph,
          body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
        }
      )
      entry.save
    }
  end

  test "should not publish a post without a summary" do
    entry = entries(:draft_post)
    assert_not entry.update(
      published: true,
      entryable_attributes: {
        summary: "a"
      }
    )
  end

  test "should not create and publish a post without a summary" do
    post = Entry.new(
      title: Faker::Games::Zelda.game,
      published: true,
      entryable: Post.new(
        summary: "a",
        body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
      )
    )
    assert_not post.save
  end

  test "should validate a posts slug" do
    post = Entry.new(
      title: "something",
      entryable: Post.new(
        slug: "some!_not allowed",
        body: "<p>Test</p>"
      )
    )
    assert_not post.save

    assert_not_empty post.errors["entryable.slug"]
    assert_equal ["is invalid"], post.errors["entryable.slug"]
  end
end
