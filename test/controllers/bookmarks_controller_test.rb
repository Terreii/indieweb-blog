require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bookmark = bookmarks(:first_bookmark)
    @entry = @bookmark.entry
  end

  test "should get index" do
    get bookmarks_url
    assert_response :success
  end

  test "should get index as json" do
    get bookmarks_url, as: :json
    assert_equal 2, response.parsed_body.length
  end

  test "should get new" do
    login
    get new_bookmark_url
    assert_response :success
  end

  test "new should require a session" do
    get new_bookmark_url
    assert_redirected_to login_path
  end

  test "should create bookmark" do
    login

    assert_difference ["Bookmark.count", "Entry.count"], 1 do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          language: Entry.languages[:english],
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end

    assert_redirected_to bookmark_url(Bookmark.last)
  end

  test "should create a bookmark with a comment" do
    login

    assert_difference ["Bookmark.count", "Entry.count"], 1 do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          language: Entry.languages[:english],
          entryable_attributes: {
            url: Faker::Internet.url,
            summary: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
          }
        }
      }
    end

    assert_redirected_to bookmark_url(Bookmark.last)
  end

  test "should create bookmark with other language" do
    login

    assert_difference ["Bookmark.count", "Entry.count"], 1 do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          language: Entry.languages[:german],
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end

    assert_equal "german", Bookmark.last.entry.language
  end

  test "create should require a session" do
    assert_no_difference("Bookmark.count") do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          language: Entry.languages[:english],
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end

    assert_redirected_to login_path
  end

  test "should always publish a bookmark" do
    # TODO: Make private bookmarks
    login

    assert_difference ["Bookmark.count", "Entry.count"], 1 do
      post bookmarks_url, params: {
        entry: {
          title: Faker::Games::Zelda.game,
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end

    assert Bookmark.last.entry.published?
  end

  test "should show bookmark" do
    get bookmark_url(@bookmark)
    assert_response :success
  end

  test "should get a bookmark as json" do
    get bookmark_url(@bookmark), as: :json
    expected = {
      "id" => @entry.id,
      "title" => @entry.title,
      "published_at" => @entry.published_at.to_json.gsub("\"", ""),
      "created_at" => @entry.created_at.to_json.gsub("\"", ""),
      "updated_at" => @entry.updated_at.to_json.gsub("\"", ""),
      "summary" => @bookmark.summary.body.as_json,
      "url" => bookmark_url(@bookmark, format: :json),
      "language" => @entry.language_code,
      "tags" => @entry.tags.pluck(:name)
    }
    assert_equal expected, response.parsed_body
  end

  test "should get edit" do
    login
    get edit_bookmark_url(@bookmark)
    assert_response :success
  end

  test "edit should require a session" do
    get edit_bookmark_url(@bookmark)
    assert_redirected_to login_path
  end

  test "should update bookmark" do
    login
    patch bookmark_url(@bookmark), params: {
      entry: {
        published: "1",
        title: @entry.title,
        entryable_attributes: {
          url: @bookmark.url
        }
      }
    }
    assert_redirected_to bookmark_url(@bookmark)
  end

  test "should update bookmark with a summary" do
    login
    patch bookmark_url(@bookmark), params: {
      entry: {
        published: "1",
        title: @entry.title,
        entryable_attributes: {
          url: @bookmark.url,
          summary: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
        }
      }
    }
    assert_redirected_to bookmark_url(@bookmark)
  end

  test "update should require a session" do
    patch bookmark_url(@bookmark), params: {
      entry: {
        published: "1",
        title: @entry.title,
        entryable_attributes: {
          url: @bookmark.url
        }
      }
    }
    assert_redirected_to login_path
  end

  test "should destroy bookmark" do
    login
    assert_difference ['Entry.count', 'Bookmark.count'], -1 do
      delete bookmark_url(@bookmark)
    end

    assert_redirected_to bookmarks_url
  end

  test "destroy should require a session" do
    assert_no_difference ['Entry.count', 'Bookmark.count'] do
      delete bookmark_url(@bookmark)
    end

    assert_redirected_to login_path
  end

  test "should enqueue a BookmarkAuthors Job if bookmark is created" do
    login

    assert_enqueued_with job: BookmarkAuthorsJob do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end
  end

  test "should enqueue a BookmarkAuthors Job if bookmark is updated" do
    login

    assert_enqueued_with job: BookmarkAuthorsJob, args: [@bookmark] do
      patch bookmark_url(@bookmark), params: {
        entry: {
          published: "1",
          title: @entry.title,
          entryable_attributes: {
            url: @bookmark.url
          }
        }
      }
    end
  end

  test "should enqueue a WebMention Job when the bookmark is created" do
    login

    assert_enqueued_with job: WebmentionJob do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: Faker::Games::Zelda.game,
          entryable_attributes: {
            url: Faker::Internet.url
          }
        }
      }
    end
  end

  test "should enqueue a WebMention Job for the url of the bookmark" do
    login
    source = bookmark_url(@bookmark)
    target = @bookmark.url

    assert_enqueued_with job: WebmentionJob, args: [{ source:, target: }] do
      patch source, params: {
        entry: {
          published: "1",
          title: @entry.title,
          entryable_attributes: {
            url: target
          }
        }
      }
    end
  end

  test "should not enqueue WebMention or BookmarkAuthors jobs if invalid" do
    login

    assert_no_enqueued_jobs do
      post bookmarks_url, params: {
        entry: {
          published: "1",
          title: "",
          entryable_attributes: {
            url: Faker::Games::Zelda.game
          }
        }
      }
    end

    assert_no_enqueued_jobs do
      patch bookmark_url(@bookmark), params: {
        entry: {
          published: "1",
          title: "",
          entryable_attributes: {
            url: Faker::Games::Zelda.game
          }
        }
      }
    end
  end
end
