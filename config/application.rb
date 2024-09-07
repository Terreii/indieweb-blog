require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IndiewebBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # no session/flash messages
    # Delete if cookie_store doesn't update the cookie on every request.
    config.session_store :disabled

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.x.accounts[:github] = {
      name: "GitHub",
      user: "@Terreii",
      domain: "github.com",
      profile: "https://github.com/Terreii"
    }
    config.x.accounts[:twitter] = {
      name: "Twitter",
      user: "@Terreii",
      domain: "twitter.com",
      profile: "https://twitter.com/terreii"
    }
    config.x.accounts[:mastodon] = {
      name: "Mastodon",
      user: "@Terreii@indieweb.social",
      domain: "indieweb.social",
      profile: "https://indieweb.social/@Terreii"
    }
    config.x.accounts[:linkedin] = {
      name: "LinkedIn",
      user: "christopher-astfalk",
      domain: "linkedin.com",
      profile: "https://www.linkedin.com/in/christopher-astfalk"
    }
  end
end
