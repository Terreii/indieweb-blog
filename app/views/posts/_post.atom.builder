feed.entry post, published: post.published_at do |entry|
  entry.title post.title
  entry.author do |author|
    author.name "Christopher Astfalk"
  end

  post.tags.each do |tag|
    entry.category term: tag.name
  end

  entry.content post.body, type: "html"
end
