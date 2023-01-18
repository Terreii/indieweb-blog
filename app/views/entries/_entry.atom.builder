feed.entry entry, {
  # recreate the id format of rails to be backwards compatible
  # https://github.com/rails/rails/blob/8015c2c2cf5c8718449677570f372ceb01318a32/actionview/lib/action_view/helpers/atom_feed_helper.rb#L184
  id: "tag:#{request.host},2005:#{entry.entryable_class}/#{entry.entryable.id}",
  published: entry.published_at,
  url: full_url_for(entry.entryable)
} do |feed_entry|
  feed_entry.title entry.title
  feed_entry.author do |author|
    author.name "Christopher Astfalk"
  end

  feed_entry.category term: entry.entryable_type.downcase

  render "entries/entryables/#{entry.entryable_name}", entry: feed_entry, entry.entryable_type.downcase.to_sym => entry.entryable
end
