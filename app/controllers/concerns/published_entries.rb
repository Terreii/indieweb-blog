module PublishedEntries
  extend ActiveSupport::Concern

  protected

    # Get published entries combined and sorted by published_at.
    # Entries are posts and bookmarks. For short: all that is displayed on the root page.
    def published_entries
      entries = (published_posts + published_bookmarks).sort_by(&:published_at)
      entries.reverse
    end

    def published_posts
      Entry.posts.published.limit 10
    end

    def published_bookmarks
      Bookmark.includes(:authors).with_rich_text_summary.limit 10
    end
end
