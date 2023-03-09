class HomeController < ApplicationController
  include PublishedEntries # adds published_entries

  before_action do
    if logged_in?
      Rack::MiniProfiler.authorize_request
    end
  end

  def index
    @entries = published_entries
  end
end
