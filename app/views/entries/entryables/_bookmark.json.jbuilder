json.extract! bookmark, :url
json.summary bookmark.summary.body
json.url bookmark_url(bookmark, format: :json)
