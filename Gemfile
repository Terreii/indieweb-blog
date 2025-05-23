source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use pg as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.6"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.4"

# Use https://github.com/bensheldon/good_job for jobs
gem "good_job", "~> 4.10"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.20"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.14"

gem "capistrano", "~> 3.19"
gem "capistrano-rails", "~> 1.7"
gem "capistrano-passenger", "~> 0.2.0"
gem "capistrano-rbenv", "~> 2.1", ">= 2.1.4"
gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
gem "ed25519"
gem "bcrypt_pbkdf"

# Parsing microformats [https://github.com/microformats/microformats-ruby]
gem 'microformats', '~> 4.4', '>= 4.4.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Create data.
  gem "faker", ">= 2.19.0"
  gem "webmock"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add a comment summarizing the current schema to the top or bottom of each model, fixture and test
  gem "annotate"

  # Ruby LSP addon for extra Rails editor features. [https://github.com/Shopify/ruby-lsp-rails]
  gem "ruby-lsp-rails"

  # Live-reloading system for Hotwire applications. [https://github.com/hotwired/spark]
  gem "hotwire-spark"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

group :production do
  # for memcached
  gem "dalli"
end
