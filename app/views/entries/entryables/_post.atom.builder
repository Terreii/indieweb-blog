unless post.summary.empty?
  entry.summary post.summary, "xml:lang" => entry_record.language_code
end

entry.content post.body, type: "html", "xml:lang" => entry_record.language_code
