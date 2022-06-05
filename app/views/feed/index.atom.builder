atom_feed do |feed|
  feed.title t('general.title')
  feed.subtitle "My blog, where I post not often."
  feed.updated @updated
  feed.author do |author|
    author.name "Christopher Astfalk"
  end

  @entries.each do |entry|
    render entry, feed:
  end
end
