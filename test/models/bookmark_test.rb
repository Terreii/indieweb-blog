# == Schema Information
#
# Table name: bookmarks
#
#  id  :bigint           not null, primary key
#  url :string
#
# Indexes
#
#  index_bookmarks_on_url  (url) UNIQUE
#
require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "should create a bookmark" do
    bookmark = Entry.new(
      title: Faker::Games::DnD.alignment,
      entryable: Bookmark.new(
        url: Faker::Internet.url,
        summary: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
      )
    )
    assert bookmark.save
  end

  test "bookmark requires a valid uri" do
    bookmark = Entry.new(
      title: Faker::Games::DnD.alignment,
      entryable: Bookmark.new(
        url: "some!_not allowed",
        summary: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
      )
    )
    assert_not bookmark.save
    puts bookmark.errors["entryable/url"]

    assert_not_empty bookmark.errors["entryable.url"]
    assert_equal ["is invalid"], bookmark.errors["entryable.url"]
  end

  test "bookmarks should not require a summary" do
    bookmark = Entry.new(
      title: Faker::Games::DnD.alignment,
      entryable: Bookmark.new(
        url: Faker::Internet.url
      )
    )
    assert bookmark.save
  end

  test "should find all published bookmarks" do
    bookmarks = Entry.published.bookmarks
    bookmark_id = bookmarks(:first_bookmark).id
    assert_equal 2, bookmarks.count
    assert_equal bookmark_id, bookmarks.last.entryable_id
  end
end
