require "test_helper"
require "webmock/minitest"

# Tests after https://authorship.rocks/
class Indieweb::AuthorTest < ActiveSupport::TestCase
  def remote_url
    "https://authorship.rocks/post/1"
  end

  # https://authorship.rocks/test/1/
  test "Entry with p-author" do
    stub_request(:get, remote_url).to_return body: <<~HTML
      <html>
        <head></head>
        <body>
          <div class="post-container h-entry">
            <div class="post-main">
              <div class="left">
                <div class="p-author">William Shakespeare</div>
              </div>
              <div class="right">
                <p class="p-name e-content">To be, or not to be: that is the question.</p>
              </div>
            </div>
          </div>
        </body>
      </html>
    HTML

    authors = Indieweb::Author.from remote_url

    assert_instance_of Array, authors
    assert_equal 1, authors.count
    assert_equal "William Shakespeare", authors.first.name
    assert_nil authors.first.url
    assert_nil authors.first.photo
  end

  # https://authorship.rocks/test/2/
  test "Entry with h-card" do
    stub_request(:get, remote_url).to_return body: <<~HTML
      <html>
        <head></head>
        <body>
          <div class="post-container h-entry">
            <div class="post-main">
              <div class="left">
                <div class="p-author h-card">
                  <a href="https://en.wikiquote.org/wiki/Homer" class="u-url">
                    <img src="/images/homer.jpg" class="u-photo" width="80">
                    <div class="p-name">Homer</div>
                  </a>
                </div>
              </div>
              <div class="right">
                <p class="p-name e-content">
                  Even in the house of Hades there is left something,
                  a soul and an image, but there is no real heart of life in it.
                </p>
              </div>
            </div>
          </div>
        </body>
      </html>
    HTML

    authors = Indieweb::Author.from remote_url

    assert_equal 1, authors.count
    assert_equal "Homer", authors.first.name
    assert_equal "https://en.wikiquote.org/wiki/Homer", authors.first.url
    assert_equal URI.join(remote_url, "/images/homer.jpg").to_s, authors.first.photo
  end

  # https://authorship.rocks/test/3/
  test "Entry with separate h-card and rel=author" do
    stub_request(:get, remote_url).to_return body: <<~HTML
      <html>
        <head></head>
        <body>
          <div class="post-container h-entry">
            <div class="post-main">
              <div class="left">
                <div class="p-author h-card">
                  <a href="/test/3/about-patanjali" class="u-url">
                    <div class="p-name">Pata&ntilde;jali</div>
                  </a>
                </div>
              </div>
              <div class="right">
                <p class="p-name e-content">
                  For one who sees the distinction, there is no further confusing of the mind with the self.
                </p>
              </div>
            </div>

            <div class="footer-text">
              <a href="/test/3/about-patanjali" rel="author">about Pata&ntilde;jali</a>
            </div>
          </div>
        </body>
      </html>
    HTML

    authors = Indieweb::Author.from remote_url

    assert_equal 1, authors.count
    assert_equal "Patañjali", authors.first.name
    assert_equal "https://authorship.rocks/test/3/about-patanjali", authors.first.url
    assert_nil authors.first.photo
  end

  # https://authorship.rocks/test/4/
  test "Entry with rel=author to an h-card with rel=me" do
    stub_request(:get, /authorship\.rocks/).to_return(
      {
        body: <<~HTML
          <html>
            <head></head>
            <body>
              <div class="post-container h-entry">
                <div class="post-main">
                  <div class="left">
                    <!-- nothing about the author -->
                  </div>
                  <div class="right">
                    <p class="p-name e-content">
                      A woman must have money and a room of her own if she is to write fiction.
                    </p>
                  </div>
                </div>

                <div class="footer-text">
                  <a href="/test/4/about-virginia-woolf" rel="author">about Virginia Woolf</a>
                </div>
              </div>
            </body>
          </html>
        HTML
      },
      {
        body: <<~HTML
          <html>
            <head></head>
            <body>
              <div class="post-container">
                <div class="post-main">
                  <div class="left">
                    <div class="h-card">
                      <a href="/test/4/about-virginia-woolf" class="u-url">
                        <img src="/images/virginia-woolf.jpg" class="u-photo">
                        <div class="p-name">Virginia Woolf</div>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </body>
          </html>
        HTML
      }
    )

    authors = Indieweb::Author.from remote_url

    assert_equal 1, authors.count
    assert_equal "Virginia Woolf", authors.first.name
    assert_equal "https://authorship.rocks/test/4/about-virginia-woolf", authors.first.url
    assert_equal "https://authorship.rocks/images/virginia-woolf.jpg", authors.first.photo
  end

  # https://authorship.rocks/test/5/
  test "Entry with rel=author to an h-card with u-url and u-uid" do
    stub_request(:get, /authorship\.rocks/).to_return(
      {
        body: <<~HTML
          <html>
            <head></head>
            <body>
              <div class="post-container h-entry">
                <div class="post-main">
                  <div class="left">
                    <!-- nothing about the author -->
                  </div>
                  <div class="right">
                    <p class="p-name e-content">
                    古池や<br>
                    蛙飛び込む<br>
                    水の音
                    </p>
                  </div>
                </div>

                <div class="footer-text">
                  <a href="/test/5/about-basho" rel="author">about Basho</a>
                </div>
              </div>
            </body>
          </html>
        HTML
      },
      {
        body: <<~HTML
          <html>
            <head></head>
            <body>
              <div class="post-container">
                <div class="post-main">
                  <div class="left">
                    <div class="h-card">
                      <a href="/test/5/about-basho" class="u-url u-uid">
                        <img src="/images/basho.jpg" class="u-photo">
                        <div class="p-name">Basho</div>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </body>
          </html>
        HTML
      }
    )

    authors = Indieweb::Author.from remote_url

    assert_equal 1, authors.count
    assert_equal "Basho", authors.first.name
    assert_equal "https://authorship.rocks/test/5/about-basho", authors.first.url
    assert_equal "https://authorship.rocks/images/basho.jpg", authors.first.photo
  end

  test "to_hash should create a hash" do
    stub_request(:get, remote_url).to_return body: <<~HTML
      <html>
        <head></head>
        <body>
          <div class="post-container h-entry">
            <div class="post-main">
              <div class="left">
                <div class="p-author h-card">
                  <a href="https://en.wikiquote.org/wiki/Homer" class="u-url">
                    <img src="/images/homer.jpg" class="u-photo" width="80">
                    <div class="p-name">Homer</div>
                  </a>
                </div>
              </div>
              <div class="right">
                <p class="p-name e-content">
                  Even in the house of Hades there is left something,
                  a soul and an image, but there is no real heart of life in it.
                </p>
              </div>
            </div>
          </div>
        </body>
      </html>
    HTML

    authors = Indieweb::Author.from remote_url
    hash = authors.first.to_hash
    assert_instance_of Hash, hash
    assert_equal "Homer", hash[:name]
    assert_equal "https://en.wikiquote.org/wiki/Homer", hash[:url]
    assert_equal URI.join(remote_url, "/images/homer.jpg").to_s, hash[:photo]
  end
end
