require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "bookmark requires a title" do
    bookmark = Bookmark.new({
      title: "",
      url: Faker::Internet.url
    })
    assert_not bookmark.save

    assert_not_empty bookmark.errors[:title]
    assert_equal ["can't be blank", "is too short (minimum is 2 characters)"], bookmark.errors[:title]
  end

  test "bookmark requires a valid uri" do
    bookmark = Bookmark.new({
      title: Faker::Games::DnD.alignment,
      url: "some!_not allowed"
    })
    assert_not bookmark.save

    assert_not_empty bookmark.errors[:url]
    assert_equal ["is invalid"], bookmark.errors[:url]
  end
end
