class HomeController < ApplicationController
  def index
    @entries = Entry.published.with_entryables.limit 10
    fresh_when @entries, public: true, cache_control: {
      max_age: 60.seconds,
      "s-maxage": 30.seconds,
      must_revalidate: true
    }
  end
end
