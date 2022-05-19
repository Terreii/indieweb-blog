require 'net/http'

class Indieweb::Author
  attr_reader :name, :url, :photo

  def initialize(remote_url)
    collection = get_doc URI(remote_url)

    return if collection.nil? || collection["items"].empty?
    return unless collection.respond_to?(:entry)

    author = select_author collection
    if author.nil? && !collection.rel_urls.empty?
      author, remote_url = follow_rel(collection, remote_url)
    end
    set_author author, remote_url
  end

  class MaxRedirect < StandardError; end

  private

    def select_author(collection)
      return collection.card if collection.respond_to?(:card)
      return collection.entry.author if collection.respond_to?(:entry) && collection.entry.respond_to?(:author)
    end

    def get_doc(remote_url)
      res = fetch_doc remote_url
      return Microformats.parse res.body unless res.body.nil?
    end

    def set_author(author, remote_url)
      @name = author.respond_to?(:name) ? author.name : author.to_s
      @url = URI.join(remote_url, author.url).to_s if author.respond_to? :url
      @photo = URI.join(remote_url, author.photo).to_s if author.respond_to? :photo
    end

    def follow_rel(collection, base_uri)
      rel = collection.rel_urls.find { |key, value| !value["rels"].nil? && value["rels"].include?("author")}
      return if rel.nil?
      url = URI.join(base_uri, rel.first)
      doc = get_doc url
      return if doc.nil?
      [select_author(doc), url]
    end

    def fetch_doc(remote_url, attempts = 50)
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
