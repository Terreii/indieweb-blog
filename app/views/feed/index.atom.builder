atom_feed do |feed|
  feed.title t('general.title')
  feed.subtitle "My blog, where I post not often."
  feed.updated @posts[0].updated_at unless @posts.empty?
  feed.author do |author|
    author.name "Christopher Astfalk"
  end

  @posts.each do |post|
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
  end
end
