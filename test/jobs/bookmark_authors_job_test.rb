require "test_helper"
require "webmock/minitest"

class BookmarkAuthorsJobTest < ActiveJob::TestCase
  def remote_url
    "https://example.com/post/1"
  end

  setup do
    stub_request(:get, /example\.com/).to_return body: <<~HTML
      <html>
        <head></head>
        <body>
          <div class="post-container h-entry">
            <div class="post-main">
              <div class="left">
                <div class="p-author h-card">
                  <a href="https://en.wikiquote.org/wiki/Homer" class="u-url">
                    <img src="/images/homer.jpg" class="u-photo" width="80">
                    <div class="p-name">Homer</div>
                  </a>
                </div>
              </div>
              <div class="right">
                <p class="p-name e-content">
                  Even in the house of Hades there is left something,
                  a soul and an image, but there is no real heart of life in it.
                </p>
              </div>
            </div>
          </div>
        </body>
      </html>
    HTML
  end

  test "should add authors" do
    bookmark = bookmarks(:second_bookmark)

    BookmarkAuthorsJob.perform_now bookmark

    bookmark.reload
    assert_equal 1, bookmark.authors.count
    assert_equal "Homer", bookmark.authors.first.name
    assert_equal "https://en.wikiquote.org/wiki/Homer", bookmark.authors.first.url
  end

  test "should update authors" do
    bookmark = bookmarks(:first_bookmark)
    old_author_id = bookmark.authors.first.id

    BookmarkAuthorsJob.perform_now bookmark

    bookmark.reload
    # assert_raise(ActiveRecord::RecordNotFound) { Bookmark.find(old_author_id) }
    assert_equal 1, bookmark.authors.count
    assert_equal "Homer", bookmark.authors.first.name
    assert_equal "https://en.wikiquote.org/wiki/Homer", bookmark.authors.first.url
  end

  test "should update existing author" do
    bookmark = bookmarks(:second_bookmark)
    bookmark.authors.create(
      name: Faker::Games::SuperSmashBros.fighter,
      url: "https://en.wikiquote.org/wiki/Homer",
      photo: nil
    )

    authors = BookmarkAuthorsJob.perform_now bookmark
    bookmark.reload
    assert_equal 1, bookmark.authors.count
    assert_equal "Homer", bookmark.authors.first.name
    assert_equal "https://en.wikiquote.org/wiki/Homer", bookmark.authors.first.url
  end
end
