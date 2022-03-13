class WebmentionJob < ApplicationJob
  queue_as :default

  class DisallowedHost < StandardError; end

  discard_on DisallowedHost

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
    res = fetch_doc

    # first check for the endpoint in the link header
    uri = webmention_from_header res
    return uri unless uri.nil?

    # if not then look in the body
    parsed_data = Nokogiri::HTML.parse res.body
    # Get the first a or link with rel="webmention"
    element = parsed_data.at_css 'a[rel="webmention"], link[rel="webmention"]'
    return nil if element.nil?

    uri = URI element.attr('href')
    return uri if check_uri uri
  end

  # Extract the WebMention uri is in a link header and extract it.
  def webmention_from_header(res)
    return if res.header[:Link].nil?
    return unless res.header[:Link].include?('rel="webmention"')
    match = /(?<=<).*(?=>)/.match(res.header[:Link])
    uri = URI(match[0])
    return uri if check_uri uri
  end

  def fetch_doc
    Net::HTTP.get_response @target
  end

  # Post the WebMention to the endpoint.
  # The format is from https://www.w3.org/TR/webmention/#sender-notifies-receiver
  def post_mention_to(endpoint)
    res = Net::HTTP.post_form endpoint, [["source", @source], ["target", @target]]
  end

  # Check if the uri is not nil, and its host is not nil nor localhost
  def check_uri(uri)
    !uri.nil? && !uri.host.nil? && uri.host != 'localhost'
  end
end
