unless post.summary.empty?
  entry.summary post.summary
end

post.tags.each do |tag|
  entry.category term: tag.name
end

entry.content post.body, type: "html"
