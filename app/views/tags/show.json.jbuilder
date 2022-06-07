json.partial! "tags/tag", tag: @tag
json.posts do
  json.array! @tag.posts.collect { |post| post_path post }
end
