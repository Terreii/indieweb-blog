json.partial! "tags/tag", tag: @tag
json.bookmarks do
  json.array! @tag.entries.bookmarks.collect { |bookmark| bookmark_path bookmark }
end
json.posts do
  json.array! @tag.entries.posts.published.collect { |post| post_path post }
end
