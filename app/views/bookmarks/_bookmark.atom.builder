feed.entry bookmark do |entry|
  entry.title bookmark.title
  entry.author do |author|
    author.name "Christopher Astfalk"
  end

  entry.category term: "bookmark"

  entry.summary bookmark.summary, type: "html"

  entry.source do |source|
    source.id bookmark.url
    source.title bookmark.title
    source.updated bookmark.updated_at
    source.link bookmark.url
    bookmark.authors.each do |author|
      source.author do |author_element|
        author_element.name author.name
        author_element.uri author.url unless author.url.nil?
      end
    end
  end
end
