atom_feed do |feed|
  feed.title t('general.title')
  feed.subtitle "My blog, where I post not often."
  feed.updated @posts[0].updated_at unless @posts.empty?
  feed.author do |author|
    author.name "Christopher Astfalk"
  end

  @posts.each do |entry|
    render entry, feed:
  end
end
