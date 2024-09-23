class ApplicationController < ActionController::Base
  include Authenticatable

  # Set the default cache headers for public facing routes.
  def default_cache(items = [])
    unless Rails.env.local?
      fresh_when items, public: true, cache_control: {
        max_age: 10.seconds,
        "s-maxage": 15.seconds,
        must_revalidate: true
      }
    end
  end
end
