class HomeController < ApplicationController
  def index
    sorted_entries = ActiveRecord::Base.connection.exec_query ApplicationRecord.sanitize_sql([
      %{
        (
          SELECT bookmarks.id, 'bookmark' as type, created_at as date FROM bookmarks
          UNION
          SELECT posts.id, 'post' as type, published_at as date FROM posts
        ) ORDER BY date desc LIMIT 20 OFFSET :offset
      },
      { offset: 0 }
    ])

    posts = Post.with_rich_text_body.find(filter_entries(sorted_entries, "post")).group_by(&:id)
    bookmarks = Bookmark.find(filter_entries(sorted_entries, "bookmark")).group_by(&:id)

    @entries = sorted_entries.map &(lambda do |info|
      id = info["id"]
      model_type = info["type"]
      return bookmarks[id].first if model_type == 'bookmark'
      return posts[id].first if model_type == 'post'
    end)
  end

  private
    def filter_entries(entries, type)
      filter = lambda { |entry| entry["id"] if entry["type"] == type }
      entries.filter_map &filter
    end
end
