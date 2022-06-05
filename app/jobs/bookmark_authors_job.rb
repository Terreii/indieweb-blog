class BookmarkAuthorsJob < ApplicationJob
  queue_as :default

  discard_on URI::InvalidURIError
  discard_on Indieweb::Author::MaxRedirect
  discard_on Indieweb::Author::HttpRequestError

  def perform(bookmark)
    @bookmark = bookmark
    ids_of_old_authors = []

    authors = Indieweb::Author.from bookmark.url
    # Create new author or update existing one
    authors.each_entry do |updated_author|
      author = get_existing_author(updated_author.name, updated_author.url)
      if author.nil?
        author = @bookmark.authors.create updated_author.to_hash
      else
        author.update updated_author.to_hash
      end
      ids_of_old_authors.push author.id
    end

    delete_old_authors(ids_of_old_authors)
  end

  # Find an existing author for that bookmark, first by url, then by name.
  # Makes up to 2 requests because I see the url as a more permanent identity.
  # Names can change or might be a nickname
  def get_existing_author(name, url)
    author = @bookmark.authors.find_by_url url unless url.nil?
    return author unless author.nil?
    @bookmark.authors.find_by_name name
  end

  # Deletes authors not in the Bookmark.
  def delete_old_authors(ids)
    authors = @bookmark.authors.where.not(id: ids)
    authors.destroy_all
  end
end
