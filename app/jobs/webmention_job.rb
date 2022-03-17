class WebmentionJob < ApplicationJob
  queue_as :default

  class DisallowedHost < StandardError; end
  class MaxRedirect < StandardError; end
  class HttpRequestError < StandardError; end

  discard_on DisallowedHost
  discard_on MaxRedirect
  discard_on HttpRequestError

  def perform(source:, target:)
    return if source.nil? || target.nil? || source.empty? || target.empty?
    @source = source
    @target = URI(target)
    raise DisallowedHost unless check_uri @target

    webmention_endpoint = fetch_endpoint
    raise DisallowedHost if webmention_endpoint.nil?

    post_mention_to webmention_endpoint
  end

  private

  # Fetch the target url and extracts the WebMention Endpoint from it.
  def fetch_endpoint
    res = fetch_doc @target

    # first check for the endpoint in the link header
    header = webmention_from_header res
    return header.uri unless header.nil?

    # if not then look in the body
    element = webmention_from_body res
    return element.uri unless element.nil?
  end

  # Check if the WebMention uri is in a link header and extract it.
  def webmention_from_header(res)
    headers = LinkHeader.parse res.header, @target
    headers.find {|header| header.webmention? && check_uri(header.uri) }
  end

  # Check if the WebMention uri is in a link or anchor element and extract it.
  def webmention_from_body(res)
    elements = DomElement.parse res.body, @target
    elements.find {|element| element.webmention? && check_uri(element.uri) }
  end

  # Get the mentioned (target) page.
  def fetch_doc(target, attempts = 50)
    raise MaxRedirect if attempts < 0
    res = Net::HTTP.get_response target
    return res if res.code == "200" || res.code == "304"

    # follow the redirects
    unless res.code.to_i >= 400 || res.header[:location].nil?
      uri = URI.join target, res.header[:location]
      fetch_doc uri, attempts -1
    else
      raise HttpRequestError
    end
  end

  # Post the WebMention to the endpoint.
  # The format is from https://www.w3.org/TR/webmention/#sender-notifies-receiver
  def post_mention_to(endpoint, attempts = 50)
    res = Net::HTTP.post_form endpoint, [["source", @source], ["target", @target]]

    # follow the redirects
    if res.code.to_i >= 300 && res.code.to_i < 400 && !res.header[:location].nil?
      uri = URI.join endpoint, res.header[:location]
      post_mention_to uri, attempts - 1
    end
  end

  # Check if the uri is not nil, and its host is not nil nor localhost
  def check_uri(uri)
    !uri.nil? && !uri.host.nil? && uri.host != 'localhost'
  end



  # Parse and store a link header
  class LinkHeader
    attr_reader :uri, :rel

    # Extract a link header form a headers hash and maps it to LinkHeader instances.
    # Works with comm a-separated link headers.
    def self.parse(headers, base_uri)
      return [] if headers[:link].nil? || headers[:link].empty?
      # only split by "," because the ruby HTTP client does merge
      # multiple headers into a single comma-separated header
      link_headers = headers[:link].split(/,\s*/).filter {|header| !header.strip.empty? }
      link_headers.map {|header| LinkHeader.new(header.strip, base_uri) }
    end

    # Parse a link header
    def initialize(header, base_uri)
      sections = header.split /;\s*/
      @uri = parse_uri sections.first, base_uri
      @rel = parse_rel sections[1..]
    end

    # Is this Link a webmention link?
    def webmention?
      @rel.include? "webmention"
    end

    private

    # Extract and parses the uri in <uri>
    def parse_uri(uri_section, base_uri)
      uri = /<(?<uri>.*)>/.match(uri_section)[:uri]
      URI.join base_uri, uri
    end

    # find and parse the rel param of this link-header.
    def parse_rel(sections)
      return [] if sections.empty?
      rel = sections.find {|section| section.downcase.include? 'rel=' }
      return [] if rel.nil?
      # find in optional " after rel=
      data = /(?<=rel=)"?(?<value>[^"]+)/.match(rel.downcase)[:value]
      data.strip.split /\s+/
    end
  end


  # Validates a link or anchor element if it is a WebMention link
  class DomElement
    attr_reader :uri, :rel

    # Find all link and anchor elements in a HTML body and parse them to DomElement
    def self.parse(body, base_uri)
      parsed_data = Nokogiri::HTML.parse body
      elements = parsed_data.css('a[rel], link[rel]')
      elements.map {|element| DomElement.new(element, base_uri) }
    end

    def initialize(element, base_uri)
      @uri = URI.join base_uri, element.attr(:href) || ''
      rel = element.attr(:rel) || ''
      @rel = rel.downcase.strip.split /\s+/
    end

    # Is this a webmention link / anchor?
    def webmention?
      @rel.include? "webmention"
    end
  end
end
