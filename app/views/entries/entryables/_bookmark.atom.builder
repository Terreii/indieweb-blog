entry.summary bookmark.summary, type: "html", "xml:lang" => entry_record.language_code

entry.source do |source|
  source.id bookmark.url
  source.title entry_record.title, "xml:lang" => entry_record.language_code
  source.updated entry_record.updated_at
  source.link rel: "alternate", type: "text/html", href: bookmark.url
  bookmark.authors.each do |author|
    source.author do |author_element|
      author_element.name author.name
      author_element.uri author.url unless author.url.nil?
    end
  end
end
