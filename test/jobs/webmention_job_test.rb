require "test_helper"
require "webmock/minitest"

class WebmentionJobTest < ActiveJob::TestCase
  def source
    "http://local-blog.de/post/test"
  end

  # https://webmention.rocks/test/1
  test "HTTP Link header, unquoted rel, relative URL" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: { link: '</webmention-endpoint>; rel=webmention' },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/2
  test "HTTP Link header, unquoted rel, absolute URL" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: { link: '<http://tester.io/webmention-endpoint>; rel=webmention' },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/3
  test "HTML <link> tag, relative URL" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="/assets/test.css" rel="stylesheet" />
            <link href="/webmention-endpoint" rel="webmention" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/4
  test "HTML <link> tag, absolute URL" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="/assets/test.css" rel="stylesheet" />
            <link href="http://tester.io/webmention-endpoint" rel="webmention" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint', body: {
      :source => source,
      :target => target
    }
  end

  # https://webmention.rocks/test/5
  test "HTML <a> tag, relative URL" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head></head>
          <body>
            <a href="/webmention-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint', body: {
      :source => source,
      :target => target
    }
  end

  # https://webmention.rocks/test/6
  test "HTML <a> tag, absolute URL" do
    stub_request(:any, /tester\.io/).to_return(
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
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint', body: {
      :source => source,
      :target => target
    }
  end

  # https://webmention.rocks/test/7
  test "HTTP Link header with strange casing" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: { LinK: '<http://tester.io/webmention-endpoint>; rel=webmention' },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/8
  test "HTTP Link header, quoted rel" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: { link: '<http://tester.io/webmention-endpoint>; rel="webmention"' },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/9
  test "Multiple rel values on a <link> tag" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="/assets/test.css" rel="stylesheet" />
            <link href="http://tester.io/webmention-endpoint" rel="webmention somethingelse" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested :post, 'http://tester.io/webmention-endpoint', body: {
      :source => source,
      :target => target
    }
  end

  # https://webmention.rocks/test/10
  test "Multiple rel values on a Link header" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: {
          link: '<http://tester.io/webmention-endpoint>; rel="webmention somethingelse"'
        },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )
    target = "http://tester.io/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_requested :get, target
    assert_requested(
      :post,
      'http://tester.io/webmention-endpoint',
      headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
      body: {
        :source => source,
        :target => target
      }
    )
  end

  # https://webmention.rocks/test/11
  test "Multiple Webmention endpoints advertised: Link, <link>, <a>" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: { link: '</webmention-endpoint>; rel="webmention"' },
        body: <<~HTML
        <html>
          <head>
          <link href="http://tester.io/other-endpoint" rel="webmention" />
          </head>
          <body>
            <a href="http://tester.io/moar-endpoints" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
    assert_not_requested :post, "http://tester.io/moar-endpoints"
  end

  # https://webmention.rocks/test/12
  test "Checking for exact match of rel=webmention" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          <link href="http://tester.io/other-endpoint" rel="not-webmention" />
          </head>
          <body>
            <a href="http://tester.io/webmention-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/13
  test "False endpoint inside an HTML comment" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          </head>
          <body>
            <!-- <a href="/other-endpoint" rel="webmention">webmention</a> -->
            <a href="/webmention-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/14
  test "False endpoint in escaped HTML" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          </head>
          <body>
            <code>&lt;a href="/other-endpoint" rel="webmention"&gt;&lt;/a&gt;</code>
            <a href="/webmention-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/15
  test "Webmention href is an empty string" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          </head>
          <body>
            <a href="" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :get, "http://tester.io/article/1"
    assert_requested :post, "http://tester.io/article/1"
  end

  # https://webmention.rocks/test/16
  test "Multiple Webmention endpoints advertised: <a>, <link>" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          </head>
          <body>
            <a href="http://tester.io/webmention-endpoint" rel="webmention">webmention</a>
            <link href="http://tester.io/other-endpoint" rel="webmention" />
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/17
  test "Multiple Webmention endpoints advertised: <link>, <a>" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
          </head>
          <body>
            <link href="http://tester.io/webmention-endpoint" rel="webmention" />
            <a href="http://tester.io/other-endpoint" rel="webmention">webmention</a>
          </body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/18
  test "Multiple HTTP Link headers" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: {
          link: [
            '<http://tester.io/other-endpoint>; rel="other"',
            '<http://tester.io/webmention-endpoint>; rel="webmention"'
          ]
        },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/19
  test "Single HTTP Link header with multiple values" do
    stub_request(:any, /tester\.io/).to_return(
      {
        headers: {
          link: '<http://tester.io/other-endpoint>; rel="other", ' +
            '<http://tester.io/webmention-endpoint>; rel="webmention"'
        },
        body: "<html><head></head><body></body></html>"
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_not_requested :post, "http://tester.io/other-endpoint"
  end

  # https://webmention.rocks/test/21
  test "Webmention endpoint has query string parameters" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="http://tester.io/webmention-endpoint?query=yes" rel="webmention" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint?query=yes"
  end

  # https://webmention.rocks/test/22
  test "Webmention endpoint is relative to the path" do
    stub_request(:any, /tester\.io/).to_return(
      {
        body: <<~HTML
        <html>
          <head>
            <link href="1/webmention-endpoint" rel="webmention" />
          </head>
          <body></body>
        </html>
        HTML
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/article/1/webmention-endpoint"
  end

  # https://webmention.rocks/test/23
  test "Webmention target is a redirect and the endpoint is relative" do
    stub_request(:any, /tester\.io/).to_return(
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
      {
        # the redirect
        status: 302,
        headers: {
          location: 'webmention-endpoint/final'
        }
      },
      { status: 202 }
    )

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :post, "http://tester.io/webmention-endpoint"
    assert_requested :post, "http://tester.io/webmention-endpoint/final"
  end

  test "original target is a redirect" do
    stub_request(:any, /tester\.io/).to_return(
      {
        # the redirect
        status: 302,
        headers: {
          location: '1/final'
        }
      },
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

    WebmentionJob.perform_now(source: source, target: "http://tester.io/article/1")

    assert_requested :get, "http://tester.io/article/1"
    assert_requested :get, "http://tester.io/article/1/final"
    assert_requested :post, "http://tester.io/webmention-endpoint"
  end

  test "that it does not fetch localhost" do
    stub_request(:any, "localhost")
    target = "http://localhost/article/1"

    WebmentionJob.perform_now(source: source, target:)

    assert_not_requested :get, target
  end

  test "that it does not post to a localhost webmention endpoint" do
    endpoint = "http://localhost/webmention-endpoint"
    stub_request(:any, /tester\.io/).to_return(
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

  test "that it does stop when no webmention endpoint is listed" do
    stub = stub_request(:any, /tester\.io/)
      .to_return body: "<html><head></head><body></body></html>"

    WebmentionJob.perform_now(source: source, target: "https://tester.io/article/1")

    assert_requested stub, times: 1
  end
end
