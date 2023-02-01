unless post.summary.empty?
  entry.summary post.summary
end

entry.content post.body, type: "html"
