json.extract! post, :slug
json.body post.body.body
json.url post_url(post, format: :json)
