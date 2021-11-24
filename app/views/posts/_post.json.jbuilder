json.extract! post, :id, :title, :published_at, :created_at, :updated_at, :body
json.url post_url(post, format: :json)
