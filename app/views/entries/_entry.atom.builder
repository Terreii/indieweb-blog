feed.entry entry, {
  # recreate the id format of rails to be backwards compatible
  # https://github.com/rails/rails/blob/8015c2c2cf5c8718449677570f372ceb01318a32/actionview/lib/action_view/helpers/atom_feed_helper.rb#L184
  id: "tag:#{request.host},2005:#{entry.entryable_class}/#{entry.entryable.id}",
  published: entry.published_at,
  url: full_url_for(entry.entryable)
} do |feed_entry|
  feed_entry.title entry.title, "xml:lang" => entry.language_code
  feed_entry.author do |author|
    author.name "Christopher Astfalk"
  end

  feed_entry.category term: entry.entryable_type.downcase

  entry.tags.each do |tag|
    feed_entry.category term: tag.name
  end

  # Render entryable part.
  # The feed entry builder is passed as entry and the entryable type is passed by its name (post ...).
  render "entries/entryables/#{entry.entryable_name}", {
    entry: feed_entry,
    entry.entryable_type.downcase.to_sym => entry.entryable,
    entry_record: entry
  }
end
