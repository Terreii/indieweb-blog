class HomeController < ApplicationController
  def index
    posts = Post.published.with_rich_text_body.limit 10
    bookmarks = Bookmark.all.limit 10
    @entries = (posts + bookmarks).sort_by { |entry| entry.published_at }
    @entries.reverse!
  end
end
