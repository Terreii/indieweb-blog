class HomeController < ApplicationController
  include PublishedEntries # adds published_entries

  def index
    @entries = published_entries
  end
end
