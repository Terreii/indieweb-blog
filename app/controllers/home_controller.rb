class HomeController < ApplicationController
  include PublishedEntries # adds published_entries

  def index
    @entries = Entry.published.with_entryables.limit 10
  end
end
