# == Schema Information
#
# Table name: entries
#
#  id             :bigint           not null, primary key
#  entryable_type :string           not null
#  language       :enum             default("english"), not null
#  published_at   :datetime
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  entryable_id   :bigint           not null
#
# Indexes
#
#  index_entries_on_entryable     (entryable_type,entryable_id)
#  index_entries_on_published_at  (published_at)
#
require "test_helper"

class EntryTest < ActiveSupport::TestCase
  test "should create post" do
    entry = Entry.new(
      title: Faker::Games::Zelda.game,
      published: true,
      entryable_type: Post.name,
      entryable_attributes: {
        body: "<p>Test Body</p>"
      }
    )
    assert entry.save
    assert entry.published?
  end

  test "should update post" do
    entry = entries(:draft_post)
    title = Faker::Kpop.boy_bands
    entry.update(title: title, entryable_attributes: { slug: Post.string_to_slug(title) })
    assert_equal title, entry.reload.title
  end

  test "should use the current time when published? is set to true" do
    entry = entries(:draft_post)
    entry.update published: true
    assert entry.published?
    assert_not_nil entry.published_at
  end

  test "should have may tags" do
    entry = entries(:first_post)
    assert_equal 2, entry.tags.count
  end

  test "should unpublish entry if published? is set to false" do
    entry = entries(:first_post)
    entry.update published: false
    assert_not entry.published?
    assert_nil entry.published_at
  end

  test "should not update published_at if published? is updated again" do
    entry = entries(:first_post)
    published_at = entry.published_at
    entry.published = true
    assert_equal published_at, entry.published_at
  end

  test "should destroy entry" do
    post = entries(:first_post)
    post.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Entry.find(post.id) }
  end

  test "should not create an entry without title" do
    entry = Entry.new entryable: Post.new(summary: "Hello")
    assert_not entry.save

    assert_not_empty entry.errors[:title]
    assert_equal ["can't be blank"], entry.errors[:title]
  end

  test "published should cast 1 and 0 strings to booleans" do
    entry = entries(:draft_post)
    entry.published = "1"
    assert entry.published?
    entry.published = "0"
    assert_not entry.published?
  end

  test "should have a class method to get permitted attributes keys" do
    assert_equal [:title, :published, :language, tag_ids: [], entryable_attributes: []], Entry.permitted_attributes_with

    assert_equal(
      [:title, :published, :language, tag_ids: [], entryable_attributes: [:test, :other, moar: []]],
      Entry.permitted_attributes_with(:test, :other, moar: [])
    )
  end
end
