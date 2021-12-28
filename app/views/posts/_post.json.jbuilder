json.extract! post, :id, :title, :slug, :published_at, :created_at, :updated_at
json.body post.body.body
json.url post_url(post, format: :json)
