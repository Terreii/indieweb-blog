require 'net/http'

# Hold IndieWeb author information.
# It can load all authors of a url by the Indieweb::Author.from method
class Indieweb::Author
  attr_reader :name, :url, :photo

  def initialize(author, remote_url)
    @name = author.respond_to?(:name) ? author.name : author.to_s
    @url = URI.join(remote_url, author.url).to_s if author.respond_to? :url
    @photo = URI.join(remote_url, author.photo).to_s if author.respond_to? :photo
  end

  # Loads a remote url and queries all authors from it.
  def self.from(remote_url)
    collection = get_doc URI(remote_url)
    authors = select_authors collection, remote_url

    return follow_rel(collection.rel_urls, remote_url) if authors.empty?

    authors
  end

  class MaxRedirect < StandardError; end

  private

    # Select all authors from that parsed page.
    # It gets all authors of the first entry and all cards
    def self.select_authors(collection, remote_url)
      authors = []

      authors += entry_authors(collection, remote_url)
      authors += cards(collection, remote_url)

      authors
    end

    # Select and instantiate all authors of the first entry.
    def self.entry_authors(collection, remote_url)
      authors = []
      if collection.respond_to?(:entry) && collection.entry.respond_to?(:author)
        # if map is used, then the data wouldn't be a Microformats::ParserResult
        collection.entry.author(:all).count.times do |index|
          author_data = collection.entry.author(index)
          author = Indieweb::Author.new author_data, remote_url
          authors.push author
        end
      end
      authors
    end

    # Select and instantiate all authors by cards.
    def self.cards(collection, remote_url)
      if collection.respond_to?(:card)
        collection.card(:all).map do |item|
          Indieweb::Author.new item, remote_url
        end
      else
        []
      end
    end

    # Fetch and parse a HTML doc into a Microformats collection
    def self.get_doc(remote_url)
      res = fetch_doc remote_url
      return Microformats.parse res.body unless res.body.nil?
    end

    # Follows all rel urls for type author and queries the returned docs for authors.
    def self.follow_rel(rel_urls, base_uri)
      return [] if rel_urls.nil?

      rels = rel_urls.filter do |key, value|
        !value["rels"].nil? && value["rels"].include?("author")
      end

      authors = []
      rels.each do |key, value|
        url = URI.join(base_uri, key)
        doc = get_doc url
        authors += select_authors(doc, url)
      end
      authors
    end

    # Fetches a html doc.
    def self.fetch_doc(remote_url, attempts = 50)
      raise MaxRedirect if attempts < 0

      res = Net::HTTP.get_response remote_url
      return res if res.code == "200" || res.code == "304"

      # follow the redirects
      unless res.code.to_i >= 400 || res.header[:location].nil?
        uri = URI.join remote_url, res.header[:location]
        fetch_doc uri, attempts -1
      else
        raise HttpRequestError
      end
    end
end
