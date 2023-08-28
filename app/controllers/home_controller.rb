class HomeController < ApplicationController
  def index
    @entries = Entry.published.with_entryables.limit 10
    unless Rails.env.test?
      fresh_when @entries, public: true, cache_control: {
        max_age: 10.seconds,
        "s-maxage": 15.seconds,
        must_revalidate: true
      }
    end
  end
end
