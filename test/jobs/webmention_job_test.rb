require "test_helper"
require "webmock/minitest"

class WebmentionJobTest < ActiveJob::TestCase
  def source
    "https://local-blog.de/post/test"
  end

  test "that it fetches the passed URI and post to its webmention endpoint" do
    stub_request(:any, "tester.io").to_return(
      {
        headers: { Link: '<http://tester.io/webmention-endpoint>; rel="webmention"' },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "https://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" }
    ) do |req|
      req.body.source == source && req.body.target == target
    end
  end

  test "that it does not fetch localhost" do
    stub_request(:any, "localhost")
    target = "https://localhost/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_not_requested :get, target
  end

  test "that it does not post to a localhost webmention endpoint" do
    endpoint = "http://localhost/webmention-endpoint"
    stub_request(:any, "tester.io").to_return(
      {
        headers: { Link: "<#{endpoint}>; rel=\"webmention\"" },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    localhost_endpoint = stub_request(:post, "localhost")

    WebmentionJob.perform_now(source: source, target: "https://tester.io/article/1")

    assert_not_requested localhost_endpoint
  end

  test "that it does get it fallsback to the link in the body" do
    stub_request(:any, "tester.io").to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="http://tester.io/webmention-endpoint" rel="webmention" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "https://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint' do |req|
      req.body.source == source && req.body.target == target
    end
  end

  test "that it does get it fallsback to the anchor in the body" do
    stub_request(:any, "tester.io").to_return(
      {
        body: <<~HTML
        <html>
          <head></head>
          <body>
            <a href="http://tester.io/webmention-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "https://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint' do |req|
      req.body.source == source && req.body.target == target
    end
  end

  test "that only the first link or anchor is used" do
    stub_request(:any, "tester.io").to_return(
      {
        body: <<~HTML
        <html>
          <head>
          <link href="http://tester.io/webmention-endpoint" rel="webmention" />
          </head>
          <body>
            <a href="http://tester.io/other-endpoint" rel="webmention">webmention</a>
            <link href="http://tester.io/moar-endpoints" rel="webmention" />
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "https://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
    assert_not_requested :post, "http://tester.io/moar-endpoints"
  end
end
