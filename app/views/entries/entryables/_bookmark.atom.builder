entry.summary bookmark.summary, type: "html"

entry.source do |source|
  source.id bookmark.url
  source.title entry_record.title
  source.updated entry_record.updated_at
  source.link bookmark.url
  bookmark.authors.each do |author|
    source.author do |author_element|
      author_element.name author.name
      author_element.uri author.url unless author.url.nil?
    end
  end
end
